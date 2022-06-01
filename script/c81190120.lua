--IJN 아카시
function c81190120.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,false,aux.FilterBoolFunction(c81190120.mat1),aux.FilterBoolFunction(Card.IsType,TYPE_SPIRIT))
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81190120,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,81190120)
	e1:SetCondition(c81190120.cn1)
	e1:SetCost(c81190120.co1)
	e1:SetTarget(c81190120.tg1)
	e1:SetOperation(c81190120.op1)
	c:RegisterEffect(e1)
	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81190120,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81190121)
	e2:SetCondition(c81190120.cn2)
	e2:SetCost(c81190120.co2)
	e2:SetTarget(c81190120.tg2)
	e2:SetOperation(c81190120.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c81190120.va3)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end

--material
function c81190120.mat1(c)
	return c:IsSetCard(0xcb6) and c:IsType(TYPE_MONSTER)
end

--search
function c81190120.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c81190120.filter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xcb6)
end
function c81190120.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81190120.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81190120.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81190120.filter2(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb6) and c:IsType(TYPE_MONSTER)
end
function c81190120.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81190120.filter2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81190120.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81190120.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--spsummon
function c81190120.cfilter(c)
	return c:IsSetCard(0xcb6) and c:IsType(TYPE_SPIRIT)
end
function c81190120.va3(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterial():FilterCount(c81190120.cfilter,nil))
end

function c81190120.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0 and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c81190120.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c81190120.filter3(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb6)
end
function c81190120.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c81190120.filter3(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c81190120.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81190120.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81190120.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end


