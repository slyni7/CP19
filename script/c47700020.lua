--미미크루 패트롤
function c47700020.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47700020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c47700020.sptg)
	e1:SetOperation(c47700020.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47700020,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetCountLimit(1,47700020)
	e2:SetTarget(c47700020.tar1)
	e2:SetOperation(c47700020.op1)
	c:RegisterEffect(e2)

end
function c47700020.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x229) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_CONTINUOUS)
end
function c47700020.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c47700020.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c47700020.filter,tp,LOCATION_SZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c47700020.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47700020.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end


function c47700020.tfil1(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and c:IsSetCard(0x229)
end
function c47700020.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c47700020.tfil1,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c47700020.tfil1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c47700020.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c47700020.tfil1,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.GetControl(g,tp)
	end
end