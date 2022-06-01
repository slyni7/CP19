--Veceta "Icicle"

function c81020141.initial_effect(c)

	--summon method
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c81020141.mfilter),2,2)
	c:EnableReviveLimit()
	
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81020141.idcn)
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
	e5:SetDescription(aux.Stringid(81020141,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,81020141)
	e5:SetCost(c81020141.spco)
	e5:SetTarget(c81020141.sptg)
	e5:SetOperation(c81020141.spop)
	c:RegisterEffect(e5)
	
end

--summon method
function c81020141.mfilter(c)
	return c:IsLevelBelow(5) and c:IsSetCard(0xca2)
end

--indes
function c81020141.idcn(e)
	return e:GetHandler():GetLinkedGroupCount()>0
end

--special summoned
function c81020141.spcofilter1(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0xca2) and c:IsAbleToRemoveAsCost()
end
function c81020141.spcofilter2(c)
	return c:IsSetCard(0x46) and c:IsAbleToRemoveAsCost()
end
function c81020141.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81020141.spcofilter1,tp,LOCATION_GRAVE,0,1,nil)
		   and Duel.IsExistingMatchingCard(c81020141.spcofilter2,tp,LOCATION_GRAVE,0,1,nil)
		end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c81020141.spcofilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c81020141.spcofilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)	
end

function c81020141.sptgfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xca2) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	and c:IsLevelBelow(5)
end
function c81020141.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c81020141.sptgfilter(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81020141.sptgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c81020141.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81020141.sptgfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
