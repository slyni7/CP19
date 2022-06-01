--KMS Z-46
local dh=LOCATION_DECK+LOCATION_HAND
function c81180030.initial_effect(c)

	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81180030,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,81180030)
	e1:SetCost(c81180030.co1)
	e1:SetTarget(c81180030.tg1)
	e1:SetOperation(c81180030.op1)
	c:RegisterEffect(e1)
	
	--self-recovery
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81180030,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,81180030)
	e2:SetCondition(c81180030.cn2)
	e2:SetTarget(c81180030.tg2)
	e2:SetOperation(c81180030.op2)
	c:RegisterEffect(e2)
end

--spsummon
function c81180030.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function c81180030.fil0(c,e,tp)
	return c:IsSetCard(0xcb5) and c:IsFaceup()
	and Duel.IsExistingMatchingCard(c81180030.spfil0,tp,dh,0,1,nil,e,tp,c:GetAttack())
	and Duel.GetMZoneCount(tp,c)>0
end
function c81180030.spfil0(c,e,tp,atk)
	return c:IsSetCard(0xcb5) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	and c:GetAttack()<atk
end
function c81180030.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81180030.fil0(chkc,e,tp)
	end
	local loc=LOCATION_DECK+LOCATION_HAND
	if chk==0 then
		return Duel.IsExistingTarget(c81180030.fil0,tp,LOCATION_MZONE,0,1,c,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c81180030.fil0,tp,LOCATION_MZONE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c81180030.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFacedown() or tc:IsImmuneToEffect(e) then
		return
	end
	if tc:IsLocation(LOCATION_MZONE) and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c81180030.spfil0,tp,dh,0,1,1,c,e,tp,tc:GetAttack())
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--self-recovery
function c81180030.filter3(c,tp)
	return c:IsSetCard(0xcb5) and c:IsControler(tp)
end
function c81180030.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81180030.filter3,1,nil,tp)
end
function c81180030.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c81180030.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(0x20)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
end


