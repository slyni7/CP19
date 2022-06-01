--함대 소집: 북방 전선
--카드군 번호: 0xc99, 0xc9a
local m=81258060
local cm=_G["c"..m]
function cm.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end

function cm.tfil0(c,tp)
	return c:IsAbleToGrave() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_UNION)
	and Duel.IsExistingMatchingCard(cm.tfil1,tp,0x01,0,1,nil,c:GetCode())
end
function cm.tfil1(c,code)
	return c:IsAbleToHand() and c:IsSetCard(0xc99) and c:IsType(0x1) and not c:IsCode(code)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01,0,1,1,nil,tp)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local tc=g:GetFirst()
		local g2=Duel.GetMatchingGroup(cm.tfil1,tp,0x01,0,nil,tc:GetCode())
		if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g2:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
