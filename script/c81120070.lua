--Chain of Mugen
function c81120070.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81120070,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81120070+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81120070.cn)
	e1:SetTarget(c81120070.tg)
	e1:SetOperation(c81120070.op)
	c:RegisterEffect(e1)
end

--activate
function c81120070.cn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c81120070.filter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c81120070.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler() and c81120070.filter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81120070.filter,tp,0,LOCATION_MZONE,1,nil)
	end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c81120070.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end	

function c81120070.sfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
	and c:IsSetCard(0xcaf) and c:IsType(TYPE_MONSTER)
end
function c81120070.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(c81120070.sfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.SelectYesNo(tp,aux.Stringid(81120070,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end
function c81120070.vcn(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	if sg:GetFlagEffect(81120070)==0 then
		e:Reset()
			return false
		end
	return true
end
function c81120070.vop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	Duel.SendtoGrave(sg,REASON_RULE)
end
