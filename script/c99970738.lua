--[ Juuki ]
local m=99970738
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발도술
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+YuL.O)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

	--덱 정렬
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(spinel.delay)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

--발도술
function cm.tar1fil(c,tp)
	local lv=c:GetLevel() if c:IsLinkMonster() then lv=c:GetLink() end
	return c:IsFaceup() and c:IsSetCard(0x3d6d)
		and lv>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>lv and Duel.IsPlayerCanDiscardDeck(tp,lv)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tar1fil(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar1fil,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tar1fil,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local ct=g:GetFirst():GetLevel() if g:GetFirst():IsLinkMonster() then ct=g:GetFirst():GetLink() end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tgc=Duel.GetFirstTarget()
	local ct=tgc:GetLevel() if tgc:IsLinkMonster() then ct=tgc:GetLink() end
	if tgc:IsFaceup() and tgc:IsRelateToEffect(e) and ct>0 then
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
		local ct2=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetCount()
		if ct2>0 then
			Duel.BreakEffect()
			if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
				local tc=Duel.GetOperatedGroup():GetFirst()
				Duel.ConfirmCards(1-tp,tc)
				if tc:IsCode(m) then
					if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
						local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,8,nil)
						if #g>0 then
							Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
						end
					end
				else
					Duel.ShuffleHand(tp)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
					local dg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,0,ct2,ct2,nil)
					if #dg>0 then
						Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
					end
				end
			end
		end
	end
end


--덱 정렬
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	Duel.SortDecktop(tp,tp,5)
end
