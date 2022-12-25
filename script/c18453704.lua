--패말림(H@NDTR@P)의 이유
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
	e3:SetCategory(CATEGORY_SEARCH)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
end
function s.nfil2(c)
	local r=c:GetReason()
	local re=c:GetReasonEffect()
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and re and r&REASON_COST~=0 and re:GetHandler()==c
end
function s.con2(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local rg=Duel.GMGroup(s.nfil2,tp,"G",0,nil)
	local ft=Duel.GetLocCount(tp,"M")
	return ft>0 and #rg>0 and aux.SelectUnselectGroup(rg,e,tp,2,2,nil,0)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=nil
	local rg=Duel.GMGroup(s.nfil2,tp,"G",0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,nil,1,tp,HINTMSG_REMOVE,nil,nil,true)
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
	local att=0
	local tc=g:GetFirst()
	while tc do
		att=att|tc:GetAttribute()
		tc=g:GetNext()
	end
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetTR(0xff,0xff)
	e1:SetValue(LSTN("R"))
	e1:SetLabel(att)
	e1:SetTarget(s.otar21)
	c:RegisterEffect(e1)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
function s.otar21(e,c)
	local att=e:GetLabel()
	return c:IsAttribute(att)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return c:IsLoc("M") or Duel.IsPlayerAffectedByEffect(tp,18453709)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local def=c:GetDefense()
	if chk==0 then
		return c:IsReleasable()
	end
	e:SetLabelObject({atk,def})
	Duel.Release(c,REASON_COST)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCL(1)
	e1:SetCondition(s.ocon31)
	e1:SetOperation(s.oop31)
	Duel.RegisterEffect(e1,tp)
end
function s.onfil31(c)
	return c:IsSetCard("H@NDTR@P") and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end
function s.ocon31(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	return Duel.GetTurnCount()~=ct and Duel.IEMCard(s.onfil31,tp,"D",0,1,nil)
end
function s.oop31(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.onfil31,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end