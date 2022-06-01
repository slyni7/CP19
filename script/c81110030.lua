--Guilty Fire-bird
function c81110030.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81110030,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,81110030)
	e1:SetCondition(c81110030.cn)
	e1:SetTarget(c81110030.tg)
	e1:SetOperation(c81110030.op)
	c:RegisterEffect(e1)
	--turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81110030,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCountLimit(1,81110031)
	e2:SetCondition(c81110030.tcn2)
	e2:SetTarget(c81110030.ttg2)
	e2:SetOperation(c81110030.top2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c81110030.tcn7)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcae))
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(800)
	c:RegisterEffect(e3)
end

--effect
function c81110030.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcae) and not c:IsCode(81110030)
end
function c81110030.cn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81110030.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
end
function c81110030.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c81110030.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+0x47e0000)
		c:RegisterEffect(e1,true)
	end
end

--turn count
function c81110030.tcn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>=2 and ep~=tp
end
function c81110030.tfilter(c)
	return c:IsSetCard(0xcae)
	and ( c:IsAbleToHand() or c:IsAbleToGrave() )
end
function c81110030.ttg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81110030.tfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81110030.top2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELCTMSG,tp,aux.Stringid(81110030,2))
	local g=Duel.SelectMatchingCard(tp,c81110030.tfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and(not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(81110030,3))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end

function c81110030.tcn7(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>=7
end
