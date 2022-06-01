--L:P(라스트 판타즘) - 암흑 도래
--카드군 번호: 0xc9b
local m=81257090
local cm=_G["c"..m]
function cm.initial_effect(c)

	--chaining
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--묘지
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--발동시
function cm.nfil0(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc9b) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return false
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(cm.nfil0,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return not re:GetHandler():IsStatus(STATUS_DISABLED)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0x0c,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x0c)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then
		return
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,0x0c,nil)
	if #g>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end

--유발
function cm.nfil0(c,tp)
	return c:IsSetCard(0xc9b) and c:IsControler(tp) and c:IsLocation(0x10)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil0,2,nil,tp)
end
function cm.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc9b) and c:IsType(0x1)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.tfil0,tp,0x10,0,1,nil)
		and c:IsAbleToRemove()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x10,0,1,1,nil)
	if #g>0 and	Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
