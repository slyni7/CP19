--멜랑홀릭: 파란 달만 쳐다보았네
local m=18452756
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","F")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","F")
	e3:SetCode(EVENT_DESTROY)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
end
function cm.ofil11(c)
	return c:IsSetCard(0x2d3) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.ofil12(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	return c:IsSetCard(0x2d3) and c:IsType(TYPE_SPELL) and not c:IsType(TYPE_FIELD)
		and Duel.GetLocCount(tp,"S")>0 and te and te:IsActivatable(tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GMGroup(cm.ofil11,tp,"D",0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		local ag=Duel.GMGroup(cm.ofil12,tp,"D",0,nil,tp)
		if Duel.IsPlayerAffectedByEffect(tp,18452752) and #ag>0 and
			Duel.SelectYesNo(tp,aux.Stringid(m,0+1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
			local tg=ag:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
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
			e:SetCategory(0)
			e:SetProperty(0)
			Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
		else
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.tfil2(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLoc("M") and cm.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,0,"M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.STarget(tp,cm.tfil2,tp,0,"M",1,1,nil)
	Duel.SOI(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		c:SetCardTarget(tc)
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetCondition(cm.ocon21)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		local e3=MakeEff(c,"FC")
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCountLimit(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetCondition(cm.ocon23)
		e3:SetOperation(cm.oop23)
		Duel.RegisterEffect(e3,1-tp)
	end
end
function cm.ocon21(e)
	local o=e:GetOwner()
	local c=e:GetHandler()
	return o:IsHasCardTarget(c) and c:GetFlagEffect(m)>0
end
function cm.ocon23(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=e:GetLabel()
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)==fid and c:GetFlagEffectLabel(m)==fid then
		return not c:IsDisabled()
	else
		e:Reset()
		return false
	end
end
function cm.oop23(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_RULE)
end
function cm.ofil3(c,tp)
	return c:GetPreviousControler()==tp and c:GetPreviousLocation()&LSTN("HO")>0
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if not re then
		return
	end
	local rc=re:GetHandler()
	if rc:IsSetCard("바이러스") and rp==tp then
		local ct=eg:FilterCount(cm.ofil3,1,nil,1-tp)
		local g=Duel.GMGroup(Card.IsFacedown,tp,0,"E",nil)
		if ct>0 and #g>0 then
			Duel.Hint(HINT_CARD,0,m)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			if ct>#g then
				ct=#g
			end
			local dg=g:RandomSelect(tp,ct)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end