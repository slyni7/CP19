--지상의 이나바

function c81060160.initial_effect(c)


	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81060160,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,81060160)
	e2:SetCondition(c81060160.spcn)
	e2:SetTarget(c81060160.sptg)
	e2:SetOperation(c81060160.spop)
	c:RegisterEffect(e2)
	
	--search to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81060160,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,81060061)
	e3:SetCondition(c81060160.shcn)
	e3:SetTarget(c81060160.shtg)
	e3:SetOperation(c81060160.shop)
	c:RegisterEffect(e3)
	
end

--special summon
function c81060160.spcn(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end

function c81060160.sptgfilter(c,e,tp)
	return c:IsFaceup()
	   and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	   and ( c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_DARK) and c:GetLevel()==2 )
end
function c81060160.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return
				chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_REMOVED)
			and c81060160.sptgfilter(chkc,e,tp)
			end
	if chk==0 then return
				Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c81060160.sptgfilter,tp,LOCATION_REMOVED,0,1,c,e,tp)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81060160.sptgfilter,tp,LOCATION_REMOVED,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c81060160.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	--summon limit
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81060160.splm)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81060160.splm(e,c)
	return not c:IsRace(RACE_BEAST)
end

--search to hand
function c81060160.shcn(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0xca7)
end

function c81060160.shtgfilter(c)
	return c:IsAbleToHand()
	   and ( c:IsSetCard(0xca8) and c:IsType(TYPE_SPELL+TYPE_TRAP) )
end
function c81060160.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_GRAVE+LOCATION_DECK
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81060160.shtgfilter,tp,loc,0,1,nil)
			end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end

function c81060160.shop(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_GRAVE+LOCATION_DECK
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81060160.shtgfilter,tp,loc,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
