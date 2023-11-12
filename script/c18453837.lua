--클래식 메모리즈 - 시로
local s,id=GetID()
function s.initial_effect(c)
	local e0=MakeEff(c,"SC")
	e0:SetCode(EVENT_TO_GRAVE)
	WriteEff(e0,0,"O")
	c:RegisterEffect(e0)
	local e4=MakeEff(c,"Qo","HG")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
	local e1=MakeEff(c,"FTo","HG")
	e1:SetCode(id+EVENT_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e1,1,"N")
	WriteEff(e1,2,"CTO")
	c:RegisterEffect(e1)
	--[[local e2=MakeEff(c,"FTo","HG")
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)]]--
	local e3=MakeEff(c,"FC","HG")
	e3:SetCode(EVENT_CHAIN_ACTIVATING)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
	if not s.global_effect then
		s.global_effect=true
		s[0]=false
		s[1]=false
		s[2]=nil
		s[3]={}
		s[4]={}
		s[5]={}
		s[6]=false
		s[7]=Group.CreateGroup()
		s[7]:KeepAlive()
		s[8]=0
		s[9]=0
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAIN_ACTIVATING)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(s.gop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=MakeEff(c,"FC")
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(s.gop3)
		Duel.RegisterEffect(ge3,0)
		local ge5=MakeEff(c,"FC")
		ge5:SetCode(EVENT_CHAIN_NEGATED)
		ge5:SetOperation(s.gop5)
		Duel.RegisterEffect(ge5,0)
		local ge6=MakeEff(c,"FC")
		ge6:SetCode(EVENT_CHAIN_DISABLED)
		ge6:SetOperation(s.gop5)
		Duel.RegisterEffect(ge6,0)
		local ge7=MakeEff(c,"FC")
		ge7:SetCode(EVENT_ADJUST)
		ge7:SetOperation(s.gop7)
		Duel.RegisterEffect(ge7,0)
	end
end
function s.gop5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>0 then
		Duel.RaiseEvent(Group.CreateGroup(),id+EVENT_CUSTOM,e,0,0,0,0)
	end
end
function s.gofil71(c)
	return c:IsOnField() and c:IsDisabled()
end
function s.gofil72(c)
	return not c:IsDisabled()
end
function s.gop7(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		return
	end
	if s[7]:IsExists(s.gofil71,1,nil) then
		Duel.RaiseEvent(Group.CreateGroup(),id+EVENT_CUSTOM,e,0,0,0,0)
	end
	local sg=Duel.GMGroup(s.gofil72,tp,"O","O",nil)
	s[7]=sg
	s[7]:KeepAlive()
end
function s.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_COST) and re and re:IsActivated() and not c:IsReason(REASON_RETURN) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,0)
	end
end
function s.gop3(e,tp,eg,ep,ev,re,r,rp)
	s[4]={}
	s[5]={}
	s[8]=0
	s[9]=0
end
function s.gofil1(c,e,tp)
	return c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	if s[2]==nil then
		s[2]={}
		local seed=Debug.GetPlayerOpSeed()
		local fname
		if seed==0 then
			fname="playerop.log"
		else
			fname="playerop "..seed..".log"
		end
		local f=io.open(fname,"r")
		if f==nil then
			Debug.Message("You can't use Classic Memories - Shiro's effect.")
			return
		end
		s[0]=Duel.IEMCard(s.gofil1,0,"HG",0,1,nil,e,tp)
		s[1]=Duel.IEMCard(s.gofil1,1,"HG",0,1,nil,e,tp)
		for line in f:lines() do
			table.insert(s[2],line)
		end
		f:close()
	end
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	aux.ClassicMemoriesShiroCheck={}
	s[3]={}
	if s[2] then
		for i=1,#s[2] do
			table.insert(s[3],s[2][i])
		end
	end
	s[2]=nil
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return s[3] and #s[3]>0
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return s[3] and #s[3]>0 and Duel.CheckEvent(id+EVENT_CUSTOM)
end
function s.cfil2(c,tp)
	if c:IsLoc("H") then
		return c:IsDiscardable()
	elseif c:IsControler(1-tp) then
		return Duel.IsPlayerAffectedByEffect(tp,76859930) and c:IsReleasable()
	else
		return c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
			and not s[4+tp][c:GetOriginalCode()]
	end
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.cfil2,tp,"HD","M",1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,s.cfil2,tp,"HD","M",1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsLoc("H") then
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	elseif tc:IsControler(1-tp) then
		Duel.Release(g,REASON_COST)
	else
		s[4+tp][tc:GetOriginalCode()]=true
		Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	end
	if tc:IsSetCard(0x2c0) then
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_INACTIVATE)
	else
		e:SetProperty(0)
	end
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return s[tp]
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		return
	end
	local c=e:GetHandler()
	local seed=Debug.GetPlayerOpSeed()
	local fname
	if seed==0 then
		fname="playerop.log"
	else
		fname="playerop "..seed..".log"
	end
	local f=io.open(fname,"w")
	for i=1,#s[3] do
		f:write(s[3][i].."\n")
	end
	f:close()
	local res0=Debug.RemoveWitchFatal(id,(tp<<31)|#s[3])
	local res1=Debug.RemoveWitchFatal(id,((1-tp)<<31)|#s[3])
	Debug.AddWitchFatal(id,(tp<<31)|#s[3])
	Debug.FromVirtualToReal(true)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	--here comes the bugs
	if Debug.GetPlayerOpConfig()~=0 then
		local lct=Debug.GetPlayerOpLine()-1
		return Debug.CheckWitchFatal(id,(tp<<31)|lct) and Duel.GetFlagEffect(tp,id)==0
	end
	local seed=Debug.GetPlayerOpSeed()
	local fname
	if seed==0 then
		fname="playerop.log"
	else
		fname="playerop "..seed..".log"
	end
	local f=io.open(fname,"r")
	if f==nil then
		Debug.Message("You can't use Classic Memories - Shiro's effect.")
		return false
	end
	local lct=0
	for line in f:lines() do
		lct=lct+1
	end
	f:close()
	--need to erase?
	return Debug.CheckWitchFatal(id,(tp<<31)|lct) and Duel.GetFlagEffect(tp,id)==0
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id)~=0 then
		return
	end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.gofil1,tp,"HG",0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	if g:GetFirst():IsLoc("M") then
		Duel.HintSelection(g)
	end
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(s.oop31)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetLabel(0)
	e2:SetOperation(s.oop32)
	Duel.RegisterEffect(e2,tp)
	local e3=MakeEff(c,"FC")
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetReset(RESET_CHAIN)
	e3:SetOperation(s.oop33)
	Duel.RegisterEffect(e3,tp)
	e3:SetLabelObject(e1)
	e1:SetLabelObject(e2)
	e2:SetLabelObject(e1)
end
function s.oop31(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		e:SetLabel(1)
		Duel.Hint(HINT_CARD,0,id)
		local c=e:GetHandler()
		local ct=Duel.GetCurrentChain()
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_CANNOT_INACTIVATE)
		e1:SetReset(RESET_CHAIN)
		e1:SetLabel(ct)
		e1:SetValue(s.ooval311)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_DISEFFECT)
		Duel.RegisterEffect(e2,tp)
		local rc=re:GetHandler()
		if rc:IsDisabled() or aux.ClassicMemoriesShiroCheck[rc] then
			aux.ClassicMemoriesShiroCheck[ct]=true
		end
	else
		e:SetLabel(0)
	end
end
function s.ooval311(e,ct)
	if e:GetLabel()~=ct then
		return false
	end
	return true
end
function s.oop32(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()>=2 then
		Duel.Recover(tp,3500,REASON_EFFECT)
		Duel.Damage(1-tp,1800,REASON_EFFECT)
	end
	e:GetLabelObject():Reset()
	e:Reset()
end
function s.oop33(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if e:GetLabelObject():GetLabel()~=0 and aux.ClassicMemoriesShiroCheck[ct] then
		local te=e:GetLabelObject():GetLabelObject()
		te:SetLabel(te:GetLabel()+1)
	end
	aux.ClassicMemoiresShiroCheck=false
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLoc("O") or c:GetFlagEffect(id)>0
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsLoc("G") or c:IsAbleToHandAsCost()
	end
	if not c:IsLoc("G") then
		Duel.SendtoHand(c,nil,REASON_COST)
		e:SetProperty(EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE)
	else
		e:SetProperty(0)
	end
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return s[8+tp]~=3
	end
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"HG")
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=s[8+tp]&0x1==0
	local b2=s[8+tp]&0x2==0
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)})
	if op==1 then
		s[8+tp]=s[8+tp]|0x1
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetR("OG",0)
		e1:SetTarget(s.otar41)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(s.oval41)
		Duel.RegisterEffect(e1,tp)
	elseif op==2 then
		s[8+tp]=s[8+tp]|0x2
		local e2=MakeEff(c,"F")
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetTargetRange(LOC_MZN_GRV_BAN,LOC_MZN_GRV_BAN)
		e2:SetValue(aux.tgoval)
		Duel.RegisterEffect(e2,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.gofil1,tp,"HG",0,0,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.BreakEffect()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SWAP_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(def)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SWAP_DEFENSE_FINAL)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
function s.otar41(e,c)
	return c:IsCode(id)
end
function s.oval41(e,te)
	return e~=te and not te:IsHasType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F)
end