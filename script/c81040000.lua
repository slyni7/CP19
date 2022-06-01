--작열 지옥장 레이우지

function c81040000.initial_effect(c)

	--enable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c81040000.filter)
	c:RegisterEffect(e2)
	
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81040000,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,81040000)
	e3:SetCondition(c81040000.sscn)
	e3:SetTarget(c81040000.sstg)
	e3:SetOperation(c81040000.ssop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e4)
	
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81040000,1))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c81040000.thco)
	e5:SetTarget(c81040000.thtg)
	e5:SetOperation(c81040000.thop)
	c:RegisterEffect(e5)
	
end

--enable
function c81040000.filter(e,te)
	return not te:GetOwner():IsSetCard(0xca4)
end
	
--special summon
function c81040000.sscn(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0xca4)
end

function c81040000.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end

function c81040000.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		Duel.Damage(1-tp,ev/2,REASON_EFFECT)
	end
end

--search
function c81040000.thco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c81040000.thtgfilter(c)
	return c:IsSetCard(0xca4)
end
function c81040000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81040000.thtgfilter,tp,LOCATION_DECK,0,1,nil) end
end

function c81040000.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c81040000.thrcn)
	e1:SetOperation(c81040000.throp)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
-- ㅡ ㅡ ㅡ ㅡ ㅡ ▼
function c81040000.thrcnfilter(c)
	return c81040000.thtgfilter(c) and c:IsAbleToHand()
end
function c81040000.thrcn(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c81040000.thrcnfilter,tp,LOCATION_DECK,0,1,nil)
end

function c81040000.throp(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,81040000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81040000.thrcnfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
