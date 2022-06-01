--Arom@ De L@ F@mili@
local m=18453202
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tfil11(c,tp)
	if not c:IsSetCard("포션") then
		return false
	end
	local te=c:CheckActivateEffect(false,false,false)
	return ((te and Duel.GetLocCount(tp,"S")>0) or c:IsAbleToHand()) and c:GetType()==TYPE_SPELL
end
function cm.tfil12(c)
	return c:IsSetCard(0x2e6) and c:IsFaceup()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil11,tp,"D",0,1,nil,tp)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IEMCard(cm.tfil12,tp,"M",0,1,nil) then
		Duel.SetChainLimit(cm.clim1)
	end
end
function cm.clim1(e,ep,tp)
	return tp==ep
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local tg=Duel.SMCard(tp,cm.tfil11,tp,"D",0,1,1,nil,tp)
	local tc=tg:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:CheckActivateEffect(false,false,false) or Duel.GetLocCount(tp,"S")<1
			or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			local tpe=tc:GetType()
			local te=tc:GetActivateEffect()
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			Duel.MoveToField(tc,tp,tp,LSTN("S"),POS_FACEUP,true)
			Duel.HintActivation(te)
			e:SetActiveEffect(te)
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
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			e:SetProperty(0)
			Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
		end
		Duel.BreakEffect()
		local pg=Group.CreateGroup()
		pg:AddCard(tc)
		pg:KeepAlive()
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_ADJUST)
		e1:SetLabelObject(pg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(cm.ocon11)
		e1:SetOperation(cm.oop11)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.onfil11(c,tp,pg)
	if not c:IsSetCard("포션") then
		return false
	end
	local code=c:GetCode()
	if code==38199696 and not Duel.IEMCard(cm.onfil12,tp,"M",0,1,nil,18453189) then
		return false
	end
	if code==20871001 and not Duel.IEMCard(cm.onfil12,tp,"M",0,1,nil,18453190,18453195) then
		return false
	end
	if code==18453197 and not Duel.IEMCard(cm.onfil12,tp,"M",0,1,nil,18453191) then
		return false
	end
	if code==18453198 and not Duel.IEMCard(cm.onfil12,tp,"M",0,1,nil,18453192,19453196) then
		return false
	end
	if code==18453199 and not Duel.IEMCard(cm.onfil12,tp,"M",0,1,nil,18453193) then
		return false
	end
	local te=c:CheckActivateEffect(false,false,false)
	return ((te and Duel.GetLocCount(tp,"S")>0) or c:IsAbleToHand()) and c:GetType()==TYPE_SPELL
		and not pg:IsExists(Card.IsCode,1,nil,code)
end
function cm.onfil12(c,code1,code2)
	return c:IsFaceup() and (c:IsCode(code1) or (code2 and c:IsCode(code2)))
end
function cm.ocon11(e,tp,eg,ep,ev,re,r,rp)
	local pg=e:GetLabelObject()
	return Duel.IEMCard(cm.onfil11,tp,"D",0,1,nil,tp,pg)
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	local pg=e:GetLabelObject()
	local ug=Group.CreateGroup()
	while Duel.IEMCard(cm.onfil11,tp,"D",0,1,nil,tp,pg) do
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local tg=Duel.SMCard(tp,cm.onfil11,tp,"D",0,1,1,nil,tp,pg)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() and (not tc:CheckActivateEffect(false,false,false) or Duel.GetLocCount(tp,"S")<1
			or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			local tpe=tc:GetType()
			local te=tc:GetActivateEffect()
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			Duel.MoveToField(tc,tp,tp,LSTN("S"),POS_FACEUP,true)
			Duel.HintActivation(te)
			e:SetActiveEffect(te)
			if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)<1 then
				tc:CancelToGrave(false)
				if Duel.GetCurrentChain()==0 then
					ug:AddCard(tc)
				end
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
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			e:SetProperty(0)
			Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
		end
		pg:AddCard(tc)
	end
	if #ug>0 then
		Duel.SendtoGrave(ug,REASON_RULE)
	end
	e:SetLabelObject(pg)
end