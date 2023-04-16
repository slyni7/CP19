--Veceta "Icicle"
local m=81020141
local cm=_G["c"..m]
function cm.initial_effect(c)

	--summon method
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(cm.mfilter),2,2)
	c:EnableReviveLimit()
	
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.idcn)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	
	--avoid
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	
	--special summoned
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m)
	e5:SetCost(cm.spco)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
	
end

--summon method
function cm.mfilter(c)
	return c:IsLinkSetCard(0xca2) and not c:IsLinkType(TYPE_LINK)
end

--indes
function cm.idcn(e)
	return e:GetHandler():GetLinkedGroupCount()>0
end

--special summoned
function cm.cfilter0(c,e,tp)
	return e:GetHandler():IsSetCard(0xca2) and c:IsHasEffect(81020200,tp) and c:IsAbleToRemoveAsCost()
end
function cm.cfilter1(c,tp)
	return c:IsType(0x2) and c:IsSetCard(0xca2) and c:IsAbleToRemoveAsCost()
	and Duel.IsExistingMatchingCard(cm.cfilter2,tp,0x10,0,1,c)
end
function cm.cfilter2(c)
	return c:IsSetCard(0x46) and c:IsAbleToRemoveAsCost()
end
function cm.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.cfilter0,tp,0x04+0x10,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.cfilter1,tp,0x10,0,1,nil,tp)
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
		local g1=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,0x10,0,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,0x10,0,1,1,g1)
		g1:Merge(g2)
		Duel.Remove(g1,POS_FACEUP,REASON_COST)
	end	
end

function cm.sptgfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xca2) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	and c:IsLevelBelow(5)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and cm.sptgfilter(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.sptgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sptgfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
