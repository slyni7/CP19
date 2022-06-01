--Standard-issue "Lunatic-Zero"

function c81060180.initial_effect(c)

	--Equip Spell
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81060180.eqtg)
	e1:SetOperation(c81060180.eqop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(c81060180.elva)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1200)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
	
	--Re Act
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81060180,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,81060180)
	e5:SetCondition(c81060180.rtcn)
	e5:SetTarget(c81060180.rttg)
	e5:SetOperation(c81060180.rtop)
	c:RegisterEffect(e5)
	
	--salvage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(81060180,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCondition(aux.exccon)
	e6:SetCost(c81060180.svco)
	e6:SetTarget(c81060180.svtg)
	e6:SetOperation(c81060180.svop)
	c:RegisterEffect(e6)
	
end

--Equip Spell
function c81060180.eqtgfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c81060180.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and c81060180.eqtgfilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81060180.eqtgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c81060180.eqtgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c81060180.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

function c81060180.elva(e,c)
	return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_DARK)
end

--Re Act
function c81060180.rtcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_LOST_TARGET) and c:IsPreviousLocation(LOCATION_SZONE)
end

function c81060180.rttgfilter(c,e,tp)
	return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_DARK)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81060180.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81060180.rttgfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end

function c81060180.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c81060180.rttgfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			Duel.Equip(tp,c,tc)
		end
	end
end

--salvage
function c81060180.svco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and c:IsLocation(LOCATION_GRAVE)
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function c81060180.svtgfilter(c)
	return c:IsSetCard(0xca9) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
	and not c:IsCode(81060180)
end
function c81060180.svtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingTarget(c81060180.svtgfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81060180.svtgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c81060180.svop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
