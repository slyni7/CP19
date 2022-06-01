--별이 내리는 노래

function c81070040.initial_effect(c)

	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c81070040.sgcn)
	e1:SetTarget(c81070040.sgtg)
	e1:SetOperation(c81070040.sgop)
	c:RegisterEffect(e1)
	
	--return to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81070040,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,81070040)
	e2:SetCondition(c81070040.vcn)
	e2:SetTarget(c81070040.vtg)
	e2:SetOperation(c81070040.vop)
	c:RegisterEffect(e2)
end

--send to grave
function c81070040.sgcnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcaa)
end
function c81070040.sgcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81070040.sgcnfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c81070040.filter2(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c81070040.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81070040.filter2,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c81070040.filter2,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function c81070040.sgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81070040.filter2,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

--return to deck
function c81070040.vcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST)
	and re:IsHasType(0x7e0) and re:GetHandler():IsSetCard(0xcaa)
end
function c81070040.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81070040.vtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsDestructable() and chkc:IsOnField() and c81070040.filter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81070040.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c81070040.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81070040.vop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
