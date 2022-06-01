--[ Juuki ]
local m=99970736
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발도술
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+YuL.O)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	
	--공수 증가
	local e2=MakeEff(c,"STo")
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(spinel.delay)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

--발도술
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.cost1fil(c)
	return c:IsSetCard(0x3d6d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cost1fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cost1fil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x3d6d)+2
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>ct and Duel.IsPlayerCanDiscardDeck(tp,ct)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op1fil(c,e,tp)
	return c:IsSetCard(0x3d6d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x3d6d)+2
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
						local ct3=2
						if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct3=1 end
						ct3=math.min(ct3,Duel.GetLocationCount(tp,LOCATION_MZONE))
						if ct3>0 then
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
							local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.op1fil),tp,LOCATION_GRAVE,0,1,ct3,nil,e,tp)
							if #g>0 then
								Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
							end
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

--공수 증가
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and aux.not_damcal()
end
function cm.tar2fil(c)
	return c:IsFaceup() and c:IsSetCard(0x3d6d)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar2fil,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tar2fil,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
