--스크립트는 사실 얀데레랍니다♡
function c27182812.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCountLimit(1,27182812+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c27182812.con1)
	e1:SetCost(c27182812.cost1)
	e1:SetTarget(c27182812.tg1)
	e1:SetOperation(c27182812.op1)
	c:RegisterEffect(e1)
end
function c27182812.nfilter1(c)
	return c:IsSetCard(0x2c2)
end
function c27182812.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)==Duel.GetMatchingGroupCount(c27182812.nfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)>1
end
function c27182812.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	Duel.ConfirmCards(1-tp,g)
end
function c27182812.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	if chk==0 then
		return ct<5
			and Duel.IsPlayerCanDraw(tp,5-ct)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5-ct)
end
function c27182812.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	if c:IsRelateToEffect(e) then
		ct=ct-1
	end
	if ct>3 then
		return
	end
	Duel.Draw(tp,4-ct,REASON_EFFECT)
end