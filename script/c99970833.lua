--[ Episode# ]
local s,id=GetID()
function s.initial_effect(c)

	--1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,id,YuL.O)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--2
	local e3=MakeEff(c,"I","G")
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(aux.bfgcost)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	
end

--1
function s.tar1fil(c)
	return c:IsSetCard(0x5d6e) and c:IsMonster() and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tar1fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.tar1fil,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--2
function s.tdfil(c)
	return c:IsSetCard(0x5d6e) and c:IsType(TYPE_XYZ) and c:IsAbleToExtra()
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.tdfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:FilterCount(Card.IsRelateToEffect,nil,e)>0 then
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	end
end
