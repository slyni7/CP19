--RedHood: Condemnation
function c99970046.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970046,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c99970046.spcon)
	e1:SetTarget(c99970046.sptg)
	e1:SetOperation(c99970046.spop)
	e1:SetCost(c99970046.spcost)
	e1:SetCountLimit(1,99970046)
	c:RegisterEffect(e1)
	
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99970046,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c99970046.cost)
	e2:SetTarget(c99970046.target)
	e2:SetOperation(c99970046.operation)
	c:RegisterEffect(e2)
	
	--공수 증감
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c99970046.utarget)
	e4:SetValue(-300)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetValue(300)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	
end

--특수 소환
function c99970046.costfilter(c)
	return c:IsSetCard(0xd34) and not c:IsPublic()
end
function c99970046.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c99970046.costfilter,tp,LOCATION_HAND,0,3,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c99970046.costfilter,tp,LOCATION_HAND,0,3,3,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c99970046.cfilter1(c)
	return c:IsSetCard(0xd34) and c:IsFaceup()
end
function c99970046.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.IsExistingMatchingCard(c99970046.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c99970046.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99970046.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Damage(1-tp,ev,REASON_EFFECT)
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

--파괴
function c99970046.cfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0xd34) and c:IsAbleToHandAsCost() and (ft>0 or c:GetSequence()<5)
end
function c99970046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c99970046.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c99970046.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),ft)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c99970046.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99970046.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--공수 증감
function c99970046.utarget(e,c)
	return c:IsSetCard(0xd34) and c:IsAttribute(ATTRIBUTE_LIGHT)
end

--저--저 죄 많은 늑대들을 전부 단죄하라.
