--AA(아트엔젤) 제니 데스사이즈
function c76859626.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetDescription(aux.Stringid(76859626,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,76859626)
	e1:SetCondition(c76859626.con1)
	e1:SetTarget(c76859626.tg1)
	e1:SetOperation(c76859626.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76859626,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,76859627)
	e2:SetCost(c76859626.cost2)
	e2:SetTarget(c76859626.tg2)
	e2:SetOperation(c76859626.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76859626,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,76859628)
	e3:SetCost(c76859626.cost3)
	e3:SetTarget(c76859626.tg3)
	e3:SetOperation(c76859626.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCountLimit(1,76859629)
	e4:SetTarget(c76859626.tg4)
	e4:SetOperation(c76859626.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCountLimit(1)
	e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e5:SetOperation(c76859626.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(76859626)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetCountLimit(1,76859630)
	e6:SetTarget(c76859626.tg6)
	e6:SetOperation(c76859626.op6)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_XYZ_LEVEL)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c76859626.val7)
	c:RegisterEffect(e7)
end
function c76859626.nfil1(c)
	return bit.band(c:GetOriginalAttribute(),ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)>0 or c:GetOriginalRace()==RACE_FAIRY
end
function c76859626.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx then
		return Duel.IsExistingMatchingCard(c76859626.nfil1,tp,LOCATION_PZONE,0,1,c)
	else
		local seq=c:GetSequence()
		local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
		return pc and c76859626.nfil(pc)
	end
end
function c76859626.tfil1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x2cd) and c:IsType(TYPE_PENDULUM) and not c:IsCode(76859626)
end
function c76859626.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return ((Duel.GetLocationCountFromEx and Duel.GetLocationCountFromEx(tp)>0)
			or (not Duel.GetLocationCountFromEx and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
			and Duel.IsExistingMatchingCard(c76859626.tfil1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c76859626.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if Duel.GetLocationCountFromEx(tp)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76859626.tfil1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c76859626.cfil2(c)
	return c:IsDiscardable() and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_FAIRY))
end
function c76859626.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859626.cfil2,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c76859626.cfil2,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c76859626.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c76859626.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c76859626.cfil3(c,tp)
	return (c:GetOriginalAttribute()==ATTRIBUTE_DARK or c:GetOriginalRace()==RACE_FAIRY) and (c:IsType(TYPE_PENDULUM) or c:IsAbleToExtraAsCost()) and ((c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c76859626.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859626.cfil3,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c76859626.cfil3,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,c,tp)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_PENDULUM) then
		Duel.SendtoExtraP(g,nil,REASON_COST)
	else
		Duel.SendtoDeck(g,nil,0,REASON_COST)
	end
end
function c76859626.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c76859626.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) then
		return
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c76859626.tfil4(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x2cd) and not c:IsCode(76859626)
end
function c76859626.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c76859626.tfil4(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c76859626.tfil4,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c76859626.tfil4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c76859626.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c76859626.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RaiseSingleEvent(c,76859626,e,0,0,0,0)
end
function c76859626.tfil6(c)
	return c:IsAbleToHand() and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c76859626.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859626.tfil6,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76859626.op6(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859626.tfil6,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c76859626.val7(e,c,rc)
	local lv=c:GetLevel()
	local tp=c:GetControler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return lv*0x10001+ct
end