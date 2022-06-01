--KMS 도이칠란트
function c81180050.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcb5),1,2,nil,nil,99)
	
	--can't activation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c81180050.cn1)
	e1:SetValue(c81180050.va1)
	c:RegisterEffect(e1)
	
	--link meta
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81180050,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCountLimit(1)
	e2:SetTarget(c81180050.tg2)
	e2:SetOperation(c81180050.op2)
	c:RegisterEffect(e2)
	
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81180050,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c81180050.co3)
	e3:SetTarget(c81180050.tg3)
	e3:SetOperation(c81180050.op3)
	c:RegisterEffect(e3)
end

--can't activation
function c81180050.cn1(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c81180050.va1(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

--link meta
function c81180050.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then
		return tc and tc:IsControler(1-tp) and tc:IsAbleToRemove(nil,POS_FACEDOWN) and tc:IsType(TYPE_LINK) 
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c81180050.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end

--destroy
function c81180050.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81180050.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return true
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_SZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81180050.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end


