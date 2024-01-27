--컬러큐브 블루
local m=18452860
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	c:EnableCounterPermit(0x2d7)
	local e2=MakeEff(c,"I","S")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCountLimit(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","S")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetDescription(aux.Stringid(m,2))
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
cm.mana_list={ATTRIBUTE_WATER}
function cm.ofil1(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	local ft=Duel.GetLocCount(tp,"S")
	return c:IsSetCard("컬러큐브") and c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS==TYPE_SPELL+TYPE_CONTINUOUS
		and (c:IsAbleToHand() or (te and ft>0 and te:IsActivatable(tp))) and not c:IsCode(m)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.ofil1,tp,"D",0,0,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			local te=tc:CheckActivateEffect(false,false,false)
			local ft=Duel.GetLocCount(tp,"S")
			if not tc:IsAbleToHand() or (te and ft>0 and te:IsActivatable(tp) and Duel.SelectYesNo(tp,aux.Stringid(m,00))) then
				local tpe=tc:GetType()
				local te=tc:GetActivateEffect()
				local co=te:GetCost()
				local tg=te:GetTarget()
				local op=te:GetOperation()
				e:SetCategory(te:GetCategory())
				e:SetProperty(te:GetProperty())
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				Duel.HintActivation(te)
				e:SetActiveEffect(te)
				te:UseCountLimit(tp,1,true)
				if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)<1 then
					tc:CancelToGrave(false)
				end
				tc:CreateEffectRelation(te)
				if co then
					co(te,tp,eg,ep,ev,re,r,rp,1)
				end
				if tg then
					tg(te,tp,eg,ep,ev,re,r,rp,1)
				end
				Duel.BreakEffect()
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				local etc=nil
				if g then
					etc=g:GetFirst()
					while etc do
						etc:CreateEffectRelation(te)
						etc=g:GetNext()
					end
				end
				if op and not tc:IsDisabled() then
					op(te,tp,eg,ep,ev,re,r,rp)
				end
				tc:ReleaseEffectRelation(te)
				if g then
					etc=g:GetFirst()
					while etc do
						etc:ReleaseEffectRelation(te)
						etc=g:GetNext()
						end
				end
				e:SetActiveEffect(nil)
				e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
				Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
			else
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("M") and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsFaceup,tp,"M",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.STarget(tp,Card.IsFaceup,tp,"M",0,1,1,nil)
	Duel.SOI(0,CATEGORY_COUNTER,nil,1,tp,0x2d7)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x2d7,1)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:GetCounter(0x2d7)>0 then
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			e1:SetLabel(c:GetCounter(0x2d7))
			e1:SetValue(cm.oval21)
			tc:RegisterEffect(e1)
		end
	end
end
function cm.oval21(e,c)
	local t={}
	local ct=e:GetLabel()
	for i=1,ct do
		table.insert(t,ATTRIBUTE_WATER)
	end
	return table.unpack(t)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(10000)
	return true
end
function cm.tfil3(c,ct)
	return c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsAbleToHand() and c:IsLevelBelow(ct)
		and (c:IsAttribute(ATTRIBUTE_WATER) or c:IsHasSquareMana(ATTRIBUTE_WATER))
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x2d7)
	if chk==0 then
		if e:GetLabel()~=10000 then
			return false
		end
		e:SetLabel(0)
		return Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil,ct)
	end
	e:SetLabel(ct)
	Duel.SendtoGrave(c,REASON_COST)
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil,ct)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end