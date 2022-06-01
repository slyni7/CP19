--[ Juuki ]
local m=99970735
local cm=_G["c"..m]
function cm.initial_effect(c)

	--링크 소환
	RevLim(c)
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3d6d),2,2)
	
	--덤핑 + 파괴
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

	--덱 정렬
	local e2=MakeEff(c,"I","M")
	e2:SetD(m,1)
	e2:SetCL(1)
	e2:SetCondition(YuL.phase(0,PHASE_MAIN2))
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--발도술
	local e3=MakeEff(c,"Qo","M")
	e3:SetD(m,2)
	e3:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCL(1,m)
	e3:SetCondition(Duel.IsMainPhase)
	e3:SetCost(spinel.relcost)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	
end

--덤핑 + 파괴
function cm.tar1fil(c,g,tp)
	return c:IsFaceup() and c:IsAttackAbove(700) and g:IsContains(c)
		and Duel.IsPlayerCanDiscardDeck(tp,math.floor(c:GetAttack()/700))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tar1fil(chkc,lg,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar1fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tar1fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lg,tp)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,math.floor(g:GetFirst():GetAttack()/700))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=math.floor(tc:GetAttack()/700)
	if not Duel.IsPlayerCanDiscardDeck(tp,ct) or ct==0 then return end
	if Duel.DiscardDeck(tp,ct,REASON_EFFECT)~=0 and tc and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--덱 정렬
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=8 end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<8 then return end
	Duel.SortDecktop(tp,tp,8)
end

--발도술
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)+1
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>ct and Duel.IsPlayerCanDiscardDeck(tp,ct)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op3fil(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x3d6d)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)+1
	if ct>0 then
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
		local ct2=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetCount()
		if ct2>0 then
			Duel.BreakEffect()
			if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
				local tc=Duel.GetOperatedGroup():GetFirst()
				Duel.ConfirmCards(1-tp,tc)
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsSetCard(0x3d6d)
					and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
				local g=Duel.GetMatchingGroup(cm.op3fil,tp,LOCATION_GRAVE,0,nil)
				if #g>0 then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
					local tg=g:Select(tp,1,8,nil)
					Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
					local og=Duel.GetOperatedGroup()
					if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
						Duel.ShuffleDeck(tp)
					end
				end
				Duel.BreakEffect()
			end
		end
	end
end
