--패말림(H@NDTR@P)의 요정
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","H")
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tar2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","HM")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_RECOVER)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	if s.global_check==nil then
		s.global_check=true
		s[0]=0
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_LEAVE_FIELD_P)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(s.gop2)
		ge2:SetLabelObject(ge1)
		Duel.RegisterEffect(ge2,0)
		local ge3=MakeEff(c,"FC")
		ge3:SetCode(EVENT_CHAINING)
		ge3:SetOperation(s.gop3)
		Duel.RegisterEffect(ge3,0)
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		for i=1,s[0] do
			local te=s[i]
			if te and tc:IsRelateToEffect(e) and te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:GetHandler()==tc
				and tc:IsStatus(STATUS_LEAVE_CONFIRMED) then
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_LEAVE,0,0)
			end
		end
		tc=eg:GetNext()
	end
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	if s[0]==0 then
		s[0]=Duel.GetCurrentChain()
	end
	s[Duel.GetCurrentChain()]=re
	local rc=re:GetHandler()
	local te=e:GetLabelObject()
	rc:CreateEffectRelation(te)
end
function s.gop3(e,tp,eg,ep,ev,re,r,rp)
	for i=1,s[0] do
		s[i]=nil
	end
	s[0]=0
end
function s.nfil2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost() and c:GetFlagEffect(id)>0
end
function s.con2(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local rg=Duel.GMGroup(s.nfil2,tp,"G",0,nil)
	local ft=Duel.GetLocCount(tp,"M")
	return ft>0 and #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,1,nil,0)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=nil
	local rg=Duel.GMGroup(s.nfil2,tp,"G",0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,1,1,nil,1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	local tc=g:GetFirst()
	local typ=tc:GetType()&0x6
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetLabel(typ)
	e1:SetValue(s.oval21)
	c:RegisterEffect(e1)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
function s.oval21(e,te)
	local typ=e:GetLabel()
	return te:IsActiveType(typ)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return c:IsLoc("M") or Duel.IsPlayerAffectedByEffect(tp,18453709)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
end