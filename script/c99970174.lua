--바벨의 도서관 장서목록
local m=99970174
local cm=_G["c"..m]
function cm.initial_effect(c)

	--바벨의 도서관 안에는 존재할 수 있는 모든 책이 존재한다.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)

	--샐비지 + 제외 + 회복
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	
end

--호르헤 루이스 보르헤스
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,99970171)
	Duel.SendtoHand(token,nil,REASON_RULE)
	Duel.ConfirmCards(1-tp,token)
end


--샐비지 + 제외
function cm.filter(c,e,tp)
	return c:IsSetCard(0xd3e) and c:GetType()==TYPE_SPELL+TYPE_QUICKPLAY and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,600)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local tc=g:FilterSelect(1-tp,cm.filter,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		g:RemoveCard(tc)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
