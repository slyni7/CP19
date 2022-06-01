function c81080130.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81080130,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,81080130)
	e1:SetTarget(c81080130.tg)
	e1:SetOperation(c81080130.op)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c81080130.cn)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81080130,1))
	e3:SetCategory(CATEGROY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,81080131)
	e3:SetTarget(c81080130.vtg)
	e3:SetOperation(c81080130.vop)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_SET_POSITION)
	e6:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e6)
end

--summon
function c81080130.cn(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0xcab)
end
function c81080130.filter(c,e,tp)
	return c:IsSetCard(0xcab) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup() )
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	and c:IsLevelAbove(1)
end
function c81080130.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_REMOVED+LOCATION_GRAVE
	if chkc then
		return chkc:IsControler(tp) and c81080130.filter(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c81080130.filter,tp,loc,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81080130.filter,tp,loc,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c81080130.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

--dump
function c81080130.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcab) and not c:IsCode(81080130) and c:IsAbleToGrave()
end
function c81080130.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81080130.filter2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGROY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function c81080130.vop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81080130.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
