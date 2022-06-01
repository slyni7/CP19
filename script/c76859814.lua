--�ƴ������� �븳
function c76859814.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c76859814.con1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,76859814)
	e2:SetTarget(c76859814.tar2)
	e2:SetOperation(c76859814.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,76859815)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(aux.exccon)
	e3:SetTarget(c76859814.tar3)
	e3:SetOperation(c76859814.op3)
	c:RegisterEffect(e3)
end
function c76859814.nfil1(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsSetCard(0x2cb))
end
function c76859814.con1(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c76859814.nfil1,tp,LOCATION_MZONE,0,1,nil)
end
function c76859814.tfil21(c,e,tp)
	local att=c:GetOriginalAttribute()
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c76859814.tfil22,tp,LOCATION_DECK,0,1,nil,e,tp,att)
end
function c76859814.tfil22(c,e,tp,att)
	return c:IsSetCard(0x2cb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetOriginalAttribute()~=att
end
function c76859814.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c76859814.tfil21,tp,0,LOCATION_MZONE,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)

	Duel.SelectTarget(tp,c76859814.tfil21,1-tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859814.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if  tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c76859814.tfil22,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetOriginalAttribute())
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c76859814.tfil3(c,e,tp)
	return c:IsSetCard(0x2cb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76859814.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c76859814.tfil3,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c76859814.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76859814.tfil3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end