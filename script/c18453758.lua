--마녀역린
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_CHAIN_END)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","HO")
	e3:SetCode(EVENT_CHAIN_ACTIVATING)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
	if not s.global_effect then
		s.global_effect=true
		s[0]=false
		s[1]=false
		s[2]=nil
		s[3]={}
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAIN_ACTIVATING)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(s.gop2)
		Duel.RegisterEffect(ge2,0)
		--[[local ge3=MakeEff(c,"FC")
		ge3:SetCode(EVENT_STARTUP)
		ge3:SetOperation(s.gop3)
		Duel.RegisterEffect(ge3,0)]]--
		local ge4=MakeEff(c,"FC")
		ge4:SetCode(EVENT_STARTUP)
		ge4:SetOperation(s.gop4)
		--Duel.RegisterEffect(ge4,0)
	end
end
function s.gofil1(c)
	return c:IsCode(id) and c:IsAbleToGrave()
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
			Debug.Message("You can't use Witch Fatal's effect.")
			return
		end
		s[0]=Duel.IEMCard(s.gofil1,0,"HO",0,1,nil)
		s[1]=Duel.IEMCard(s.gofil1,1,"HO",0,1,nil)
		for line in f:lines() do
			table.insert(s[2],line)
		end
		f:close()
	end
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	s[3]={}
	if s[2] then
		for i=1,#s[2] do
			table.insert(s[3],s[2][i])
		end
	end
	s[2]=nil
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return s[3] and #s[3]>0
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
		Debug.Message("You can't use Witch Fatal's effect.")
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
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.gofil1,tp,"HO",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	if g:GetFirst():IsLoc("G") then
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
	e1:SetLabelObject(e2)
	e2:SetLabelObject(e1)
end
function s.oop31(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainNegatable(ev) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local rc=re:GetHandler()
		Duel.Hint(HINT_CARD,0,id)
		if Duel.NegateActivation(ev) and not re:IsHasProperty(EFFECT_FLAG_CANNOT_NEGATE) then
			Duel.ChangeChainOperation(ev,function() end)
			e:GetLabelObject():SetLabel(e:GetLabelObject():GetLabel()+1)
			if rc:IsRelateToEffect(re) then
				Duel.Destroy(rc,REASON_EFFECT)
			end
		end
	end
end
function s.oop32(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()<2 then
		Duel.SetLP(tp,math.floor(Duel.GetLP(tp)/2))
	end
	e:GetLabelObject():Reset()
	e:Reset()
end
function s.gop3(e,tp,eg,ep,ev,re,r,rp)
	local i=1
	local te=Debug.GetIDEffect(i)
	local ct=Debug.GetInfosFieldID()
	while i<ct do
		Debug.Message(i)
		if te then
			if te:GetHandler() then
				Debug.Message(te:GetHandler())
			else
				Debug.Message("GlobalEffect")
			end
		else
			Debug.Message("not Effect")
		end
		i=i+1
		te=Debug.GetIDEffect(i)
	end
end
function s.gop4(e,tp,eg,ep,ev,re,r,rp)
	local res=Debug.CheckWitchFatal(id,1243)
	Debug.Message(res)
end