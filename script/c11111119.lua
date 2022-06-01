--μ(마이크로) 땅토끼
local m=11111119
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11111112,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1f5),1,true,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCondition(cm.con2)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(cm.con2)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1f5))
	c:RegisterEffect(e3)
end
function cm.nfil2(c)
	return c:IsSetCard(0x1f5) and c:IsFaceup()
end
function cm.con2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.nfil2,tp,LOCATION_MZONE,0,3,nil)
end
function cm.val2(e,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(cm.nfil2,tp,LOCATION_MZONE,0,nil)
	return #g*500
end