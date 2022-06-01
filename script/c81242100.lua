--무신의 사역(뿌리 왕저)
--카드군 번호: 0xc89
local m=81242100
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--코스트 대체
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(endofroots)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,m)
	c:RegisterEffect(e2)
end

--제거
function cm.tfil0(c)
	return c:IsReleasableByEffect() and c:IsSetCard(0xc89)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then 
		return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(cm.tfil0,tp,0x04,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,0x0c,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectTarget(tp,cm.tfil0,tp,0x04,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g1,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,0x0c,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
	if g2:GetFirst():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_RELEASE)
	local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local sg1=tg1:GetFirst()
	local sg2=tg2:GetFirst()
	if not sg1:IsRelateToEffect(e) or not sg2:IsRelateToEffect(e) then
		return false
	end
	if not sg2:IsOnField() or sg2:IsControler(tp) then
		return
	end
	if Duel.Release(tg1,REASON_EFFECT)~=0 and Duel.Destroy(tg2,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
		