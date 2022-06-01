--Pristene Melody

function c81070130.initial_effect(c)
	
	c:EnableReviveLimit()
	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c81070130.spcn)
	e2:SetOperation(c81070130.spop)
	c:RegisterEffect(e2)
	
	--copy name
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(81070000)
	c:RegisterEffect(e3)

	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81070130,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,81070131)
	e5:SetCost(c81070130.stco)
	e5:SetTarget(c81070130.sttg)
	e5:SetOperation(c81070130.stop)
	c:RegisterEffect(e5)
	
end

--special summon
function c81070130.spcnfilter(c)
	return c:IsSetCard(0xcaa) and not c:IsPublic() and not c:IsCode(81070130)
end
function c81070130.spcn(e,c)
	if c==nil then return true end
	local tp=c:GetControler() local mg=Duel.GetMatchingGroup(c81070130.spcnfilter,tp,LOCATION_HAND,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetClassCount(Card.GetCode)>=1
end

function c81070130.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local mg=Duel.GetMatchingGroup(c81070130.spcnfilter,tp,LOCATION_HAND,0,nil)
	local g=mg:Select(tp,1,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
end

--set
function c81070130.stcofilter(c)
	return c:IsAbleToGraveAsCost()
	   and c:IsFaceup() and ( c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
end
function c81070130.stco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81070130.stcofilter,tp,LOCATION_SZONE,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81070130.stcofilter,tp,LOCATION_SZONE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SendtoGrave(g,REASON_COST)
end

function c81070130.sttgfilter(c,rc)
	return c:IsSSetable(true) and c:IsSetCard(0xcaa)
	and c:GetType()&TYPE_CONTINUOUS+TYPE_TRAP==TYPE_CONTINUOUS+TYPE_TRAP
	and not c:IsCode(rc)
end
function c81070130.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81070130.sttgfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel())
			end
end

function c81070130.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c81070130.sttgfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
