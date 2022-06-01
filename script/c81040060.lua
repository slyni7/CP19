--영멸의 핵까마귀

function c81040060.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,c81040060.tfilter,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_FIRE),1)
	
	--treat "Reiuji"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(81040000)
	c:RegisterEffect(e1)
	
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81040060,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,81040060+EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c81040060.dstg)
	e2:SetOperation(c81040060.dsop)
	c:RegisterEffect(e2)

	--dam.imp.
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81040060,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c81040060.dicn)
	e3:SetOperation(c81040060.diop)
	c:RegisterEffect(e3)
	
end

--Tuner
function c81040060.tfilter(c)
	return c:IsSetCard(0xca4)
end

--destroy
function c81040060.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function c81040060.operfilter(c)
	return c:IsSetCard(0xca4) and c:IsFaceup()  and c:IsAbleToHand()
end
function c81040060.dsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		local sg=Duel.GetMatchingGroup(c81040060.operfilter,tp,LOCATION_REMOVED,0,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81040060,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local tg=sg:Select(tp,1,2,nil)
			Duel.HintSelection(tg)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		end
	end
end

--dam. imp.
function c81040060.dicn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end

function c81040060.diop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c81040060.value)
	Duel.RegisterEffect(e1,tp)
end

function c81040060.value(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then
		local turn=1+(Duel.GetTurnCount()/20)
		return dam*turn
	else return dam end
end
