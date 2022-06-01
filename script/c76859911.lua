--클래식 메모리얼 - 아야세
local m=76859911
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=MakeEff(c,"SC")
	e0:SetCode(EVENT_TO_GRAVE)
	WriteEff(e0,0,"O")
	c:RegisterEffect(e0)
	local e1=MakeEff(c,"Qo","HG")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(m,1))
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e2:SetCL(1,m)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","G")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCL(1)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_COST) and re and re:IsActivated() and not c:IsReason(REASON_RETURN) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,0)
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==3
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.tfil2(c)
	return c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"G",0,1,nil) and Duel.IEMCard(aux.TRUE,tp,0,"O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.STarget(tp,cm.tfil2,tp,"G",0,1,1,nil)
	Duel.SOI(0,CATEGORY_REMOVE,g,#g,0,0)
	local dg=Duel.GMGroup(aux.TRUE,tp,0,"O",nil)
	Duel.SOI(0,CATEGORY_DESTROY,dg,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if ct>0 then
			local dg=Duel.GMGroup(aux.TRUE,tp,0,"O",nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=dg:Select(tp,1,ct,nil)
			Duel.HintSelection(sg)
			DUel.Destroy(sg,REASON_EFFECT)
		end
	end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=MakeEff(c,"SC")
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetOperation(cm.oop21)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BE_BATTLE_TARGET)
		c:RegisterEffect(e2)
		local e3=MakeEff(c,"S","M")
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetValue(5600)
		e3:SetCondition(cm.con23)
		c:RegisterEffect(e3)
	end
end
function cm.op21(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		bc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		bc:RegisterEffect(e2)
	end
end
function cm.con23(e,c)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)>0
end
function cm.cfil4(c,tp)
	if c:IsLoc("H") then
		return c:IsDiscardable()
	elseif c:IsControler(1-tp) then
		return Duel.IsPlayerAffectedByEffect(tp,76859930) and c:IsReleasable()
	else
		return Duel.GetFlagEffect(tp,m)==0 and c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
	end
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil4,tp,"HD","M",1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,cm.cfil4,tp,"HD","M",1,1,nil,tp)
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
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFacedown()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsFacedown,tp,0,"O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,Card.IsFacedown,tp,0,"O",1,e:GetLabel()+1,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local e1=MakeEff(c,"F")
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_CHANGE_POS)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EVENT_MSET)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e4,tp)
	e2:SetOperation(cm.oop42(e1,e3,e4))
	e3:SetOperation(cm.oop43(e1,e2,e4))
	e4:SetOperation(cm.oop43(e1,e2,e3))
end
function cm.oofil42(c,tp)
	return c:IsFacedown() and c:IsControler(tp) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.oop42(e1,e2,e3)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(cm.oofil42,nil,1-tp)
		if #g==0 then
			return
		end
		if Duel.Destroy(g,REASON_EFFEFCT)>0 then
			Duel.Hint(HINT_CARD,0,m)
			e1:Reset()
			e2:Reset()
			e3:Reset()
			e:Reset()
		end
	end
end
function cm.oofil43(c,tp)
	return c:IsFacedown() and c:IsControler(tp)
end
function cm.oop43(e1,e2,e3)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(cm.oofil43,nil,1-tp)
		if #g==0 then
			return
		end
		if Duel.Destroy(g,REASON_EFFEFCT)>0 then
			Duel.Hint(HINT_CARD,0,m)
			e1:Reset()
			e2:Reset()
			e3:Reset()
			e:Reset()
		end
	end
end