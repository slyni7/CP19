--하핑몬의 수호자
local m=18453041
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.con4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
end
function cm.nfil1(c,tp)
	return c:IsFaceup() and c:IsCode(18453038) and c:IsAbleToHandAsCost() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.nfil1,tp,LOCATION_ONFIELD,0,1,nil,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.nfil1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.nfil2(c,tp)
	return c:IsCode(18453038) and c:IsFaceup() and c:GetSummonPlayer()==tp
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil2,1,nil,tp)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(cm.oclim2)
end
function cm.oclim2(e,rp,tp)
	return tp==rp
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0xffe) and rp==tp
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(cm.oclim2)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(cm.oval51)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(cm.oval52)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
end
function cm.oval51(e,c,sumtype)
	if not c then
		return sumtype==SUMMON_TYPE_FUSION
	end
	return sumtype==SUMMON_TYPE_FUSION and not c:IsRace(RACE_WARRIOR)
end
function cm.oval52(e,c)
	if not c then
		return false
	end
	return not c:IsRace(RACE_WARRIOR)
end