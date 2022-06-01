--하이퍼큐빅 라프테노스
local m=52647106
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
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetTargetRange(LSTN("M"),0)
	e2:SetTarget(cm.tar2)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","M")
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetTargetRange(LSTN("M"),0)
	e4:SetValue(cm.val4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
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
function cm.tar2(e,c)
	return c:GetOriginalType()&TYPE_EFFECT==TYPE_EFFECT
end
function cm.vfil4(c)
	return (c:IsFaceup() or c:IsLoc("G")) and c:IsType(TYPE_NORMAL)
end
function cm.val4(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GMGroup(cm.vfil4,tp,"MG",0,nil)
	return g:GetClassCount(Card.GetCode)*100
end