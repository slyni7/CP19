--클래식 메모리얼 - 나데코
local m=76859913
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=MakeEff(c,"SC")
	e0:SetCode(EVENT_TO_GRAVE)
	WriteEff(e0,0,"O")
	c:RegisterEffect(e0)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_TOGRAVE)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCL(1)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_COST) and re and re:IsActivated() and not c:IsReason(REASON_RETURN) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,0)
	end
end
function cm.cfil1(c,tp)
	return c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
		and Duel.IEMCard(cm.tfil1,tp,"D",0,1,c)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable() and Duel.IEMCard(cm.cfil1,tp,"D",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SMCard(tp,cm.cfil1,tp,"D",0,1,1,nil)
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
end
function cm.tfil1(c)
	return c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,2,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)>0
end
function cm.cfil2(c,tp)
	if c:IsLoc("H") then
		return c:IsDiscardable()
	elseif c:IsControler(1-tp) then
		return Duel.IsPlayerAffectedByEffect(tp,76859930) and c:IsReleasable()
	else
		return Duel.GetFlagEffect(tp,m)==0 and c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil2,tp,"HD","M",1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,cm.cfil2,tp,"HD","M",1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsLoc("H") then
		e:SetLabel(1)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	elseif tc:IsControler(1-tp) then
		e:SetLabel(0)
		Duel.Release(g,REASON_COST)
	else
		e:SetLabel(0)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	end
end
function cm.tfil2(c)
	return c:IsSetCard(0x2c0) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and cm.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.tfil2,tp,"G",0,1,e:GetLabel()+1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,#g,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=MakeEff(c,"F")
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.oop22)
	Duel.RegisterEffect(e2,tp)
end
function cm.oop22(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if rp==tp or loc~=LSTN("G") then
		return
	end
	if Duel.NegateEffect(ev) then
		Duel.Hint(HINT_CARD,0,m)
		local rc=re:GetHandler()
		if rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
		local te=e:GetLabelObject()
		te:Reset()
		e:Reset()
	end
end