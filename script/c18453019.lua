--举府胶 橇肺琉
local m=18453019
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","S")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","G")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetCountLimit(1,m+1)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function cm.nfil2(c)
	return c:IsCode(m) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(cm.nfil2,tp,"O",0,1,nil)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	c:SetStatus(STATUS_EFFECT_ENABLED,true)
end
function cm.tfil2(c)
	return c:IsSetCard("举府胶") and c:IsType(TYPE_SPELL) and (c:IsAbleToHand() or c:IsAbleToGrave()) and not c:IsCode(m)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
end
function cm.ofil2(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup() and c:IsHasExactSquareMana(ATTRIBUTE_WATER)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local th=tc:IsAbleToHand()
		local tg=tc:IsAbleToGrave()
		local op=0
		if th and tg then
			op=Duel.SelectOption(tp,1190,1191)
		elseif th then
			op=0
		else
			op=1
		end
		if op==0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
		local ct=0
		local g1=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"H",nil)
		local g2=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"O",nil)
		local g3=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"G",nil)
		local rct=0
		if #g1>0 then
			rct=rct+1
		end
		if #g2>0 then
			rct=rct+1
		end
		if #g3>0 then
			rct=rct+1
		end
		while ct<rct do
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
			local sg=Duel.SMCard(tp,cm.ofil2,tp,"M",0,0,1,nil)
			local sc=sg:GetFirst()
			if sc then
				if ct<1 then
					Duel.BreakEffect()
				end
				ct=ct+1
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.oval21)
				sc:RegisterEffect(e1)
			else
				break
			end
		end
		local tg=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"HOG",nil)
		local og=Group.CreateGroup()
		while ct>0 and #tg>0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=tg:Select(tp,1,1,nil)
			local rc=rg:GetFirst()
			og:Merge(rg)
			local loc=rc:GetLocation()
			if loc&LSTN("O")>0 then
				loc=LSTN("O")
			end
			tg:Remove(Card.IsLoc,nil,loc)
			ct=ct-1
		end
		Duel.Remove(og,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.oval21(e,c)
	return ATTRIBUTE_WATER
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LSTN("HO"),0)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,ct*100)
end
function cm.ofil3(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LSTN("HO"),0)
	if Duel.Recover(tp,ct*100,REASON_EFFECT)>0 then
		local sg=Duel.GMGroup(cm.ofil3,tp,"M",0,nil)
		local sc=sg:GetFirst()
		if sc then
			Duel.BreakEffect()
		end
		while sc do
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.oval21)
			sc:RegisterEffect(e1)
			sc=sg:GetNext()
		end
	end
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c:CreateEffectRelation(e)
end
function cm.tfil4(c,tp)
	if c:IsCode(m) then
		return false
	end
	local te=c:CheckActivateEffect(false,false,false)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return te and c:IsSetCard("举府胶") and (ft>0 or c:IsType(TYPE_FIELD)) and c:IsType(TYPE_SPELL) and te:IsActivatable(tp)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil4,tp,"D",0,1,nil,tp)
	end
end
function cm.ofil4(c)
	return c:IsCode(18453009) and c:IsFaceup()
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local tg=Duel.SelectMatchingCard(tp,cm.tfil4,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=tg:GetFirst()
	if tc then
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local co=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		if bit.band(tpe,TYPE_FIELD)>0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		Duel.HintActivation(te)
		tc:CreateEffectRelation(te)
		e:SetActiveEffect(te)
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
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(0)
		Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
	end
	if Duel.IEMCard(cm.ofil4,tp,"M",0,1,nil) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) then
		local e1=MakeEff(c,"FC","R")
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.ocon41)
		e1:SetOperation(cm.oop41)
		c:RegisterEffect(e1)
	end
end
function cm.ocon41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocCount(tp,"S")>0 and c:IsSSetable()
end
function cm.oop41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SSet(tp,c)
end