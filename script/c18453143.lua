--스타피시 파워
local m=18453143
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,7,2,cm.pfil1,aux.Stringid(m,0),2,cm.pop1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.afil1)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","M")
	e3:SetCode(EVENT_TO_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FC","M")
	e4:SetCode(EVENT_TO_HAND)
	WriteEff(e4,4,"NO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FC","M")
	e5:SetCode(EVENT_CHAIN_SOLVED)
	WriteEff(e5,5,"NO")
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.pfil1(c)
	return c:IsFaceup() and c:IsRace(RACE_FISH) and not c:IsType(TYPE_XYZ)
end
function cm.pop1(e,tp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)>0 or Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)>0
	end
	return true
end
function cm.afil1(re,tp,cid)
	local rc=re:GetHandler()
	return not (rc:IsRace(RACE_FISH) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LSTN("H"))
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsImmuneToEffect(re) then
		return
	end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g<1 then
		return
	end
	if g:IsContains(c) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		c:ReleaseEffectRelation(re)
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
function cm.tfil21(c)
	return c:IsSetCard(0x2e3) and c:IsCanOverlay()
end
function cm.tfil22(c)
	return c:IsRace(RACE_FISH) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("M") and cm.tfil22(chkc)
	end
	if chk==0 then
		return Duel.IEMCard(cm.tfil21,tp,"D",0,1,nil) and Duel.IETarget(cm.tfil22,tp,"M",0,1,nil)
	end
	Duel.STarget(tp,cm.tfil22,tp,"M",0,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_XYZ) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OVERLAY)
		local g=Duel.SMCard(tp,cm.tfil21,tp,"D",0,1,1,nil)
		if #g>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	cm.chain_solving=true
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	cm.chain_solving=false
end
function cm.nfil3(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LSTN("D")) and not c:IsReason(REASON_DRAW)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return #c:GetOverlayGroup()>0 and eg:IsExists(cm.nfil3,1,nil,tp) and not cm.chain_solving
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local ct=eg:FilterCount(cm.nfil3,nil,tp)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return #c:GetOverlayGroup()>0 and eg:IsExists(cm.nfil3,1,nil,tp) and cm.chain_solving
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=eg:FilterCount(cm.nfil3,nil,tp)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,ct)
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return #c:GetOverlayGroup()>0 and c:GetFlagEffect(m)>0
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	local labels={c:GetFlagEffectLabel(m)}
	local ct=0
	for i=1,#labels do
		ct=ct+labels[i]
	end
	c:ResetFlagEffect(m)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
