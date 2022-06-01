--shu-siki

function c81080050.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81080050.spcn)
	e1:SetOperation(c81080050.spop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81080050,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,81080050)
	e2:SetCost(c81080050.eqco)
	e2:SetTarget(c81080050.tg1)
	e2:SetOperation(c81080050.op1)
	c:RegisterEffect(e2)
	
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c81080050.dscn)
	e3:SetCost(c81080050.dsco)
	e3:SetTarget(c81080050.dstg)
	e3:SetOperation(c81080050.dsop)
	c:RegisterEffect(e3)
	
end

--special summon
function c81080050.spcn(e,c)
	if c==nil then 
		return true
	end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
	and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,0)>0
	and Duel.GetCustomActivityCount(81080050,tp,ACTIVITY_SUMMON)==0
	and Duel.GetCustomActivityCount(81080050,tp,ACTIVITY_SPSUMMON)==0
end
function c81080050.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81080050.lim)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c81080050.lim(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xcab)
end

--equip
function c81080050.eqco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				e:GetHandler():IsAbleToRemoveAsCost()
			end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c81080050.tfil0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xcab)
end
function c81080050.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81080050.tfil0,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81080050.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81080050.tfil0,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--destroy
function c81080050.dscnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcab) and c:IsType(TYPE_MONSTER)
end
function c81080050.dscn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81080050.dscnfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81080050.dsco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function  c81080050.dstgfilter(c)
	return c:IsFaceup() and c:IsDestructable() and c:IsLocation(LOCATION_ONFIELD)
end
function c81080050.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81080050.dstgfilter,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c81080050.dstgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81080050.dsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end





