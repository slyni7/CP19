--[ Juuki ]
local m=99970737
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발도술
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+YuL.O)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--세트
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

--발도술
function cm.tar1fil(c)
	return c:IsFaceup() and c:IsSetCard(0x3d6d)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(cm.tar1fil,tp,LOCATION_MZONE,0,nil)+2
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>ct and Duel.IsPlayerCanDiscardDeck(tp,ct)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.tar1fil,tp,LOCATION_MZONE,0,nil)+2
	if ct>0 then
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
		local ct2=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetCount()
		if ct2>0 then
			Duel.BreakEffect()
			if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
				local tc=Duel.GetOperatedGroup():GetFirst()
				Duel.ConfirmCards(1-tp,tc)
				if tc:IsCode(m) then
					if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
						local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
						Duel.SendtoHand(sg,nil,REASON_EFFECT)
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

--세트
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetValue(LOCATION_DECKBOT)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e2)
	end
end
