--OQA 브레이크
--카드군 번호: 0xcad
--refined 20.02.16.
local m=81100100
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동시
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end

--발동시
function cm.tfil0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xcad)
end
function cm.cfil0(c)
	return c:IsAbleToGraveAsCost() and c:IsFaceup() and c:IsSetCard(0xcad)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil)
	local b2=Duel.IsExistingTarget(aux.TRUE,tp,0,0x0c,1,nil)
	local c2=Duel.IsExistingMatchingCard(cm.cfil0,tp,0x40,0,1,nil)
	if chk==0 then
		return b1 or (b2 and c2)
	end
	local op=0
	if b1 and (b2 and c2) then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	if b1 and (not b2 or not c2) then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	end
	if not b1 and (b2 and c2) then
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x10)
	else
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local rg=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x40,0,1,1,nil)
		Duel.SendtoGrave(rg,REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,0x0c,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
