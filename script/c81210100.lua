--성전 기사단
--카드군 번호: 0xcb9(아이리스 리브레)
function c81210100.initial_effect(c)
	aux.AddCodeList(c,81210090)
	--특수소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81210100)
	e1:SetTarget(c81210100.tg1)
	e1:SetOperation(c81210100.op1)
	c:RegisterEffect(e1)
	
	--장착효과
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81210101)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81210100.tg2)
	e2:SetOperation(c81210100.op2)
	c:RegisterEffect(e2)
end

--특수소환
function c81210100.filter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)	and c:IsSetCard(0xcb9)
end
function c81210100.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return true
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-1 then loc=LOCATION_MZONE end 
	if ft>0 then loc=LOCATION_ONFIELD end
	if chk==0 then
		return ft>-1
		and Duel.IsExistingTarget(aux.TRUE,tp,loc,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c81210100.filter0,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,loc,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c81210100.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c81210100.filter0,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--장착효과
function c81210100.tfil0(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c81210100.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81210100.tfil0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81210100.tfil0,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81210100.tfil0,tp,LOCATION_MZONE,0,1,1,nil,e)
end
function c81210100.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetDescription(aux.Stringid(81210100,0))
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end
