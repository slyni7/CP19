local m=81020170
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunction(cm.mfilter),aux.FilterBoolFunction(Card.IsAttackAbove,2000))
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.cn)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.vcn)
	e2:SetCost(cm.vco)
	e2:SetTarget(cm.vtg)
	e2:SetOperation(cm.vop)
	c:RegisterEffect(e2)
end

cm.material_setcode=0xca2
--material
function cm.mfilter(c,fc,sumtype,tp)
	return c:IsSetCard(0xca2,fc,sumtype,tp) and c:IsType(TYPE_MONSTER,fc,sumtype,tp)
end

--salvage
function cm.cn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xca2) and c:IsType(TYPE_SPELL)
	and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--effect
function cm.vcn(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
	and rp~=tp
	and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
	and Duel.IsChainDisablable(ev)
end
function cm.cfilter0(c,e,tp)
	return e:GetHandler():IsSetCard(0xca2) and c:IsHasEffect(81020200,tp) and c:IsAbleToRemoveAsCost()
end
function cm.cfilter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xca2) and c:IsType(0x2)
end
function cm.vco(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.cfilter0,tp,0x04+0x10,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.cfilter1,tp,0x02+0x10,0,2,nil)
	if chk==0 then
		return b1 or b2
	end
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(81020200,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter0,tp,0x04+0x10,0,1,1,nil,e,tp)
		local te=g:GetFirst():IsHasEffect(81020200,tp)
		if te then
			te:UseCountLimit(tp)
			Duel.Remove(g,POS_FACEUP,REASON_REPLACE)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,0x02+0x10,0,2,2,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function cm.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.vop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
