--RedHood: Murder
function c99970043.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970043,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c99970043.spcon)
	e1:SetTarget(c99970043.sptg)
	e1:SetOperation(c99970043.spop)
	e1:SetCountLimit(1,99970043)
	c:RegisterEffect(e1)
	
	--샐비지
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99970043,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c99970043.thcost)
	e2:SetTarget(c99970043.thtg)
	e2:SetOperation(c99970043.thop)
	c:RegisterEffect(e2)
	
	--회수
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99970043,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetCost(c99970043.retcost)
	e3:SetCondition(c99970043.retcon)
	e3:SetTarget(c99970043.rettg)
	e3:SetOperation(c99970043.retop)
	c:RegisterEffect(e3)
	
	if not c99970043.global_check then
	c99970043.global_check=true
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_SUMMON_SUCCESS)
	ge1:SetLabel(99970043)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ge1:SetOperation(aux.sumreg)
	Duel.RegisterEffect(ge1,0)
	local ge2=ge1:Clone()
	ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
	ge2:SetLabel(99970043)
	Duel.RegisterEffect(ge2,0)
	end
	
end

--특수 소환
function c99970043.cfilter(c)
	return c:IsSetCard(0xd34) and c:IsFaceup()
end
function c99970043.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.IsExistingMatchingCard(c99970043.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99970043.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function c99970043.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Damage(1-tp,ev,REASON_EFFECT)
	end
end

--샐비지
function c99970043.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(99970043)~=0 end
	e:GetHandler():ResetFlagEffect(99970043)
end
function c99970043.thfilter(c)
	return c:IsSetCard(0xd34) and c:IsAbleToHand()
end
function c99970043.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99970043.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99970043.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c99970043.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99970043.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--회수
function c99970043.retfilter(c)
	return c:IsSetCard(0xd34) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToGraveAsCost()
end
function c99970043.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970043.retfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99970043.retfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99970043.retcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and rp~=tp 
end
function c99970043.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c99970043.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

--죽이는 쪽과 죽는 쪽이 언제부터 바뀌었던가.
