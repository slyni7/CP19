--Inebriation: The Lantern of Causality
local m=99970338
local cm=_G["c"..m]
function cm.initial_effect(c)

	--스피릿
	aux.EnableSpiritReturn(c,EVENT_SPSUMMON_SUCCESS)
	
	--패 발동
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCountLimit(1,m)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)

	--The Lantern of Causality
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.lanterncost)
	e1:SetTarget(cm.lanterntg)
	e1:SetOperation(cm.lanternop)
	c:RegisterEffect(e1)
	
	--무효
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.negcon)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)

end

--패 발동
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)
end

--The Lantern of Causality
function cm.costfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xe09)
end
function cm.lanterncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	e:SetLabel(cg:GetCount())
end
function cm.lanterntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe09,0x221,0,1000,9,RACE_PYRO,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.lanternop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe09,0x221,0,1000,9,RACE_PYRO,ATTRIBUTE_FIRE) then
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPIRIT)
		Duel.SpecialSummonStep(c,1,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(e:GetLabel()*1000)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end

--무효
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainDisablable(ev) and e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-500)
		c:RegisterEffect(e1)
	end
end
