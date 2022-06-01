--[ Tinnitus ]
local m=99970411
local cm=_G["c"..m]
function cm.initial_effect(c)

	--타깃 설정
	local e0=MakeEff(c,"FC","M")
	e0:SetCategory(CATEGORY_COUNTER)
	e0:SetCode(EVENT_ADJUST)
	WriteEff(e0,0,"NO")
	c:RegisterEffect(e0)
	
	--서치 / 샐비지
	local e1=MakeEff(c,"STo")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCL(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	--덱 바운스
	local e3=MakeEff(c,"Qo","M")
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCL(1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)

end

--타깃 설정
function cm.con0fil(c)
	return c:GetCounter(0x1e1c)>0
end
function cm.con0(e)
	return not Duel.IsExistingMatchingCard(cm.con0fil,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(cm.op0fil,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil,e)
end
function cm.op0fil(c,e)
	return not c:IsImmuneToEffect(e) and c:IsFaceup()
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.op0fil,tp,0,LOCATION_MZONE,nil,e)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,m)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		sg:GetFirst():AddCounter(0x1e1c,1,REASON_EFFECT)
	end
end

--서치 / 샐비지
function cm.tar1fil(c)
	return c:IsSetCard(0xe1c) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar1fil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tar1fil),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--덱 바운스
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1e1c,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1e1c,1,REASON_COST)
end
function cm.tar3fil(c)
	return c:IsType(YuL.ST) and c:IsAbleToDeck()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and cm.tar3fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar3fil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tar3fil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		Duel.SendtoDeck(tc,nil,opt,REASON_EFFECT)
	end
end
