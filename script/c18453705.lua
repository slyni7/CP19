--패말림(H@NDTR@P)의 마법
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
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetD(id,0)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","HM")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetD(id,1)
	WriteEff(e4,3,"NC")
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
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
	return s.nfil21(c) or s.nfil22(c)
end
function s.nfil21(c)
	local r=c:GetReason()
	local re=c:GetReasonEffect()
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and re and r&REASON_COST~=0 and re:GetHandler()==c
end
function s.nfil22(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost() and c:GetFlagEffect(id)>0
end
function s.nfun2(sg,e,tp,mg)
	return sg:IsExists(s.nfil21,1,nil) and sg:IsExists(s.nfil22,1,nil)
end
function s.con2(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local rg=Duel.GMGroup(s.nfil2,tp,"G",0,nil)
	local ft=Duel.GetLocCount(tp,"M")
	return ft>0 and #rg>0 and aux.SelectUnselectGroup(rg,e,tp,2,2,s.nfun2,0)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=nil
	local rg=Duel.GMGroup(s.nfil2,tp,"G",0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,s.nfun2,1,tp,HINTMSG_REMOVE,nil,nil,true)
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
		return c:IsReleasable() and Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0
	end
	Duel.Release(c,REASON_COST)
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTR(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsFaceup() and chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsFaceup,tp,"O","O",1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.STarget(tp,Card.IsFaceup,tp,"O","O",1,1,nil)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0,fid)
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabel(Duel.GetTurnCount())
		if Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		e1:SetLabelObject({tc,fid})
		e1:SetCL(1)
		e1:SetCondition(s.ocon31)
		e1:SetOperation(s.oop31)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.ocon31(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local lo=e:GetLabelObject()
	local tc=lo[1]
	local fid=lo[2]
	if tc:GetFlagEffectLabel(id)~=fid then
		e:Reset()
		return false
	end
	return Duel.GetTurnCount()~=ct
end
function s.oop31(e,tp,eg,ep,ev,re,r,rp)
	local lo=e:GetLabelObject()
	local tc=lo[1]
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsFaceup() and chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsFaceup,tp,"O","O",1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.STarget(tp,Card.IsFaceup,tp,"O","O",1,1,nil)
	Duel.SOI(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabel(Duel.GetTurnCount())
		if Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		e1:SetLabelObject(tc)
		e1:SetCL(1)
		e1:SetCondition(s.ocon41)
		e1:SetOperation(s.oop41)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.ocon41(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	return Duel.GetTurnCount()~=ct
end
function s.oop41(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end