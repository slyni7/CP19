--CytusII Lv.14 SECRET;WEAPON
function c112600044.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(112600044,0))
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCountLimit(1,112600044)
	e1:SetCondition(c112600044.spcon)
	e1:SetOperation(c112600044.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112600044,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(c112600044.destg)
	e2:SetOperation(c112600044.desop)
	c:RegisterEffect(e2)
end
function c112600044.spfilter(c,tp)
	return c:IsReleasable() and Duel.GetSZoneCount(1-tp,c,tp)>0
end
function c112600044.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c112600044.spfilter,tp,0,LOCATION_SZONE,1,nil,tp)
end
function c112600044.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c112600044.spfilter,tp,0,LOCATION_SZONE,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c112600044.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c112600044.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c112600044.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c112600044.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c112600044.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c112600044.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
