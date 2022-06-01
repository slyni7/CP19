--데스펙터 프라임
local m=99000246
local cm=_G["c"..m]
function cm.initial_effect(c)
	--order summon
	aux.AddOrderProcedure(c,"L",nil,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),cm.ordfil1,cm.ordfil2)
	c:EnableReviveLimit()
	--Godfrey
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.indcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
cm.CardType_Order=true
function cm.ordfil1(c)
	return not c:IsType(TYPE_TOKEN) and c:IsType(TYPE_MONSTER)
end
function cm.ordfil2(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and (c:GetSummonLocation()==LOCATION_DECK or c:GetSummonLocation()==LOCATION_EXTRA)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local exc=aux.ExceptThisCard(e)
	local dg=Group.CreateGroup()
	local chk=true
	while chk do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,exc)
		local tc=g:GetFirst()
		while tc do
			local preatk=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
			tc=g:GetNext()
		end
		if Duel.Destroy(dg,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_CARD,0,m)
			chk=true
		else chk=false
		end
	end
end
function cm.cfilter(c)
	return c:IsSetCard(0xc18)
end
function cm.indcon(e)
	return Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end