--모노크로니클 데미안
local m=76859508
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","M")
	e2:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","M")
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCountLimit(1,m+1)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e4:SetCountLimit(1,m+2)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil1(c)
	return c:IsSetCard(0x2c6) and c:IsType(TYPE_FIELD) and (c:IsFaceup() or not c:IsLoc("R"))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"DGR",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,0,tp,"DGR")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"DGR",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and Duel.SelectYesNo(tp,16*m) then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LSTN("F"),POS_FACEUP,true)
		end
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetDefense()<800 then
		return
	end
	if c:IsImmuneToEffect(re) then
		return
	end
	if rp==tp then
		return
	end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g<1 then
		return
	end
	if g:IsContains(c) then
		c:ReleaseEffectRelation(re)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-800)
		c:RegisterEffect(e1)
	end
end
function cm.nfil3(c,tp)
	return c:GetPreviousControler()==tp and c:GetPreviousTypeOnField()&TYPE_FIELD>0
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil3,1,nil,tp)
end
function cm.tfil3(c)
	local te=c:CheckActivateEffect(false,false,false)
	return c:IsType(TYPE_FIELD) and (c:IsAbleToHand() or (te and te:IsActivatable(tp,true,true)))
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"DG",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,0,tp,"DG")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"DG",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local te=tc:CheckActivateEffect(false,false,false)
		local b1=tc:IsAbleToHand()
		local b2=te:IsActivatable(tp,true,true)
		if b1 and (not b2 or Duel.SelectYesNo(tp,16*m)) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.HintActivation(te)
			e:SetActiveEffect(te)
			te:UseCountLimit(tp,1,true)
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
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
			if op then
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
			e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local fc=Duel.GetFieldCard(tp,LSTN("S"),5)
	if chk==0 then
		return fc and fc:IsSetCard(0x2c6) and fc:IsReleasable()
	end
	Duel.Release(fc,REASON_COST)
end
function cm.tfil4(c,tp)
	return c:IsAbleToGrave() or Duel.IsPlayerCanDraw(tp,1)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and cm.tfil4(chkc,tp)
	end
	if chk==0 then
		local fc=e:GetLabel()>0 and Duel.GetFieldCard(tp,LSTN("S"),5) or nil
		e:SetLabel(0)
		return Duel.IETarget(cm.tfil4,tp,"O","O",1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.STarget(tp,cm.tfil4,tp,"O","O",1,1,nil,tp)
	Duel.SOI(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAbleToGrave() and
		(not Duel.IsPlayerCanDraw(tp,1) or Duel.SelectYesNo(tp,16*m+1)) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end