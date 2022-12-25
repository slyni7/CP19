--패말림(H@NDTR@P)의 절망
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
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(s.val3)
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
	return ft>0 and #rg>0 and aux.SelectUnselectGroup(rg,e,tp,3,3,nil,0)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=nil
	local rg=Duel.GMGroup(s.nfil2,tp,"G",0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,3,3,nil,1,tp,HINTMSG_REMOVE,nil,nil,true)
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
	local sg=g:Clone()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_REMOVE,0,0,fid)
		tc=sg:GetNext()
	end
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e4:SetLabel(fid)
	e4:SetLabelObject(sg)
	sg:KeepAlive()
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
function s.val3(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function s.tfil4(c,e,sg,fid)
	return sg:IsContains(c) and c:GetFlagEffectLabel(id)==fid and c:IsCanBeEffectTarget(e)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sg=e:GetLabelObject()
	local fid=e:GetLabel()
	if chkc then
		return s.tfil4(chkc,e,sg,fid)
	end
	if chk==0 then
		return sg:IsExists(s.tfil4,1,nil,e,sg,fid)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=sg:FilterSelect(tp,s.tfil4,1,1,nil,e,sg,fid)
	Duel.SetTargetCard(g)
	local tc=g:GetFirst()
	tc:CreateEffectRelation(e)
	Duel.SOI(0,CATEGORY_TOHAND,g,0,0,0)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local fid=c:GetFieldID()
		tc:ResetFlagEffect(id)
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
		e1:SetCondition(s.ocon41)
		e1:SetOperation(s.oop41)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.ocon41(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local lo=e:GetLabelObject()
	local tc=lo[1]
	local fid=lo[2]
	if tc:GetFlagEffectLabel(id)~=fid then
		e:Reset()
		return false
	end
	return Duel.GetTurnCount()~=ct and tc:IsAbleToHand()
end
function s.oop41(e,tp,eg,ep,ev,re,r,rp)
	local lo=e:GetLabelObject()
	local tc=lo[1]
	Duel.SendtoHand(tc,nli,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end