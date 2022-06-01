--흑곡의 물거미

function c81050020.initial_effect(c)

	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c81050020.spcn)
	e2:SetOperation(c81050020.spop)
	c:RegisterEffect(e2)
	
	--bounce
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81050020,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,81050020)
	e3:SetTarget(c81050020.bctg)
	e3:SetOperation(c81050020.bcop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP)
	c:RegisterEffect(e4)
	
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81050020,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,81050020)
	e5:SetCondition(c81050020.dscn)
	e5:SetTarget(c81050020.dstg)
	e5:SetOperation(c81050020.dsop)
	c:RegisterEffect(e5)
	
end

--special summon
function c81050020.spcnfilter(c)
	return ( c:IsLocation(LOCATION_HAND) or c:IsFaceup() ) and c:IsReleasable()
	   and c:IsRace(RACE_INSECT)
end
function c81050020.spcn(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c81050020.spcnfilter,1,e:GetHandler(),c)
	 and ( Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		or Duel.CheckReleaseGroup(tp,c81050020.spcnfilter,1,e:GetHandler(),c) )
end

function c81050020.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		local g1=Duel.SelectReleaseGroup(tp,c81050020.spcnfilter,1,1,e:GetHandler(),c)
		Duel.Release(g1,REASON_MATERIAL)
	else
		local g=Duel.SelectReleaseGroupEx(tp,c81050020.spcnfilter,1,1,e:GetHandler(),c)
		Duel.Release(g,REASON_MATERIAL)
	end
end

--bounce
function c81050020.bctgfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c81050020.bctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsOnField()
			and chkc:IsControler(1-tp)
			and c81050020.bctgfilter(chkc)
			end
	if chk==0 then return 
				Duel.IsExistingMatchingCard(c81050020.bctgfilter,tp,0,LOCATION_ONFIELD,1,nil)
			end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end

function c81050020.bcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c81050020.bctgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

--destroy
function c81050020.dscn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end

function c81050020.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsOnField()
			and chkc:IsDestructable()
			end
	if chk==0 then return
				Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function c81050020.dsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
