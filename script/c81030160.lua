--dangan

function c81030160.initial_effect(c)

	--지속 마법
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--패에서 지속 마법 카드로 놓는다.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81030160,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,81030160)
	e2:SetTarget(c81030160.sztg)
	e2:SetOperation(c81030160.szop)
	c:RegisterEffect(e2)
	
	--대상지정 파괴
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81030160,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,81030161)
	e3:SetCondition(c81030160.decn)
	e3:SetTarget(c81030160.detg)
	e3:SetOperation(c81030160.deop)
	c:RegisterEffect(e3)
	
end

function c81030160.sztgfilter(c)
	return c:IsSetCard(0xca3) and c:IsType(TYPE_MONSTER)
end
function c81030160.sztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81030160.sztgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end
function c81030160.szop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINT_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c81030160.sztgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end

function c81030160.decn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return 
	( c:IsReason(REASON_COST) and re:IsHasType(0x7e0) 
		and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xca3) )
	or
	( bit.band(c:GetReason(),0x41)==0x41 and re:GetOwner():IsSetCard(0xca3) )
end
function c81030160.detg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp) and c81030160.detgfilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c81030160.deop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end


