--신천지의 새하얀 눈
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCL(1,id)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(1,1)
	e2:SetTarget(s.tar2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTR(1,1)
	e3:SetValue(s.val3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FC","M")
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetOperation(s.op4)
	c:RegisterEffect(e4)
end
function s.nfil1(c)
	return c:IsFacedown() or not c:IsSetCard("신천지")
end
function s.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0 and not Duel.IEMCard(s.nfil1,tp,"M",0,1,nil)
end
function s.tar2(e,c)
	return c:IsLevel(2) or c:IsRank(2) or c:IsLink(2)
end
function s.val3(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsLevel(2) or rc:IsRank(2) or rc:IsLink(2)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsLevel(2) or rc:IsRank(2) or rc:IsLink(2) then
		Duel.NegateEffect(ev)
	end
end