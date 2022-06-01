--하이퍼큐빅 와이암 
local m=52647105
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.pfil1,2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LSTN("M"),0,Duel.Release,REASON_COST+REASON_MATERIAL)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetTargetRange(LSTN("M"),0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
end
function cm.pfil1(c,fc,sub,mg,sg)
	if not c:IsCustomType(CUSTOMTYPE_SQUARE) or not c:IsFusionType(TYPE_NORMAL) then
		return false
	end
	if not sg or sg:FilterCount(aux.TRUE,c)==0 then
		return true
	end
	local g=sg:Clone()
	g:AddCard(c)
	local st=fc.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.val1(e,se,sp,st)
	return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function cm.val2(e,c)
	return not c:IsType(TYPE_NORMAL)
end
function cm.val3(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end