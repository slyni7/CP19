--[ Tinnitus ]
local m=99970418
local cm=_G["c"..m]
function cm.initial_effect(c)

	--서치 + 카운터 제거
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,m+YuL.O)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--회수
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_TODECK)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	
end

--서치 + 카운터 제거
function cm.tar1fil(c)
	return c:IsSetCard(0xe1c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar1fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op1fil(c)
	return c:GetCounter(0x1e1c)>0
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tar1fil,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local sg=Duel.GetMatchingGroup(cm.op1fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #sg>0 then
			Duel.BreakEffect()
			for tc in aux.Next(sg) do
				tc:RemoveCounter(tp,0x1e1c,tc:GetCounter(0x1e1c),REASON_EFFECT)
			end
		end
	end
end

--회수
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1e1c,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1e1c,1,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
