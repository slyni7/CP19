--클래식 메모리얼 - 사토네
local m=76859908
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=MakeEff(c,"SC")
	e0:SetCode(EVENT_TO_GRAVE)
	WriteEff(e0,0,"O")
	c:RegisterEffect(e0)
	local e1=MakeEff(c,"F","HG")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","H")
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_DRAW)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","H")
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetValue(SUMMON_TYPE_NORMAL)
	e3:SetCondition(cm.con3)
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
	local e4=MakeEff(c,"FC","M")
	e4:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e4,4,"O")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"Qo","G")
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCL(1)
	WriteEff(e5,5,"NCTO")
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>=4 then
		cm[0]=cm[0]+1
	end
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_COST) and re and re:IsActivated() and not c:IsReason(REASON_RETURN) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,0)
	end
end
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,m)<cm[0] and Duel.GetLocCount(tp,"M")>0
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RegisterFlagEffect(tp,m,RESET_PHSAE+PHASE_END,0,1)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil2(c,se)
	return c:IsSetCard(0x2c0) and c:IsSummonable(true,se)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local se=e:GetLabelObject()
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"H",0,1,c,se)
	end
	Duel.SOI(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"H",0,1,1,nil,se)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,se)
		if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function cm.con3(e,c,minc)
	if c==nil then
		return true
	end
	return minc==0 and Duel.CheckTribute(c,0)
end
function cm.ofil4(c,e,tp)
	return c:IsControler(tp) and c:IsLoc("M") and c:IsFaceup() and c:IsSetCard(0x2c0) and c:GetAttack()>=600
		and not c:IsImmuneToEffect(e)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then
		return
	end
	local sg=g:Filter(cm.ofil4,nil,e,tp)
	if #sg==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local tg=sg:Select(tp,0,#sg,nil)
	local tc=tg:GetFirst()
	while tc do
		tc:ReleaseEffectRelation(re)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-600)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)>0
end
function cm.cfil5(c,tp)
	if c:IsLoc("H") then
		return c:IsDiscardable()
	elseif c:IsControler(1-tp) then
		return Duel.IsPlayerAffectedByEffect(tp,76859930) and c:IsReleasable()
	else
		return Duel.GetFlagEffect(tp,m+1)==0 and c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
	end
end
function cm.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil5,tp,"HD","M",1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,cm.cfil5,tp,"HD","M",1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsLoc("H") then
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	elseif tc:IsControler(1-tp) then
		Duel.Release(g,REASON_COST)
	else
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	end
end
function cm.tfil5(c,e,tp)
	return c:IsSetCard(0x2c0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(5)
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil5,tp,"D",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,cm.tfil5,tp,"D",0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=MakeEff(c,"F")
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_SUMMON)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.oop52)
	Duel.RegisterEffect(e2,tp)
end
function cm.oop52(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		return
	end
	if Duel.NegateSummon(eg) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Destroy(eg,REASON_EFFECT)
		local te=e:GetLabelObject()
		te:Reset()
		e:Reset()
	end
end