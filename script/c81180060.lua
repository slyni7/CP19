--KMS 어드미럴 히퍼
function c81180060.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcb5),1,2,nil,nil,99)

	--link meta
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81180060,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetTarget(c81180060.tg1)
	e1:SetOperation(c81180060.op1)
	c:RegisterEffect(e1)
	
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81180060.cn2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c81180060.va3)
	c:RegisterEffect(e3)
	
	--free chain
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81180060,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c81180060.cn4)
	e4:SetCost(c81180060.co4)
	e4:SetOperation(c81180060.op4)
	c:RegisterEffect(e4)
end

--link meta
function c81180060.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then
		return tc and tc:IsControler(1-tp) and tc:IsAbleToRemove(nil,POS_FACEDOWN) and tc:IsType(TYPE_LINK) 
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c81180060.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end

--indes
function c81180060.cn2(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c81180060.va3(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end

--indes inc
function c81180060.cn4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c81180060.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,2,REASON_COST)
	end
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c81180060.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTarget(c81180060.tg01)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c81180060.va01)
	e1:SetReset(RESET_EVENT+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(c81180060.va02)
	Duel.RegisterEffect(e2,tp)
end
function c81180060.tg01(e,c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xcb5) and c:IsFaceup()
end
function c81180060.va01(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end
function c81180060.va02(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end


