--IJN 카와카제
function c81190040.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_SPIRIT),2,false)
	
	--atk inc.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81190040,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCountLimit(1)
	e1:SetCondition(c81190040.cn1)
	e1:SetOperation(c81190040.op1)
	c:RegisterEffect(e1)
	
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81190040,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81190040)
	e2:SetCost(c81190040.co2)
	e2:SetTarget(c81190040.tg2)
	e2:SetOperation(c81190040.op2)
	c:RegisterEffect(e2)
end

--material
function c81190040.mat(c)
	return c:IsType(TYPE_SPIRIT) and c:IsType(TYPE_MONSTER)
end

--atk inc.
function c81190040.cn1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsType(TYPE_EFFECT) and not bc:IsType(TYPE_SPIRIT)
end
function c81190040.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
		if bc:IsType(TYPE_EFFECT) and not bc:IsDisabled() then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
			bc:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			bc:RegisterEffect(e4)
		end
	end
end

--tograve
function c81190040.filter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SPIRIT)
end
function c81190040.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81190040.filter1,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81190040.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81190040.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToGrave()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c81190040.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end


