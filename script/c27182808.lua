--스크립트리니티-프래터니티
function c27182808.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,27182808)
	aux.AddXyzProcedure(c,c27182808.xfilter,3,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(27182801)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(c27182808.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c27182808.tg2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetValue(c27182808.val4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetTarget(c27182808.tg5)
	e5:SetOperation(c27182808.op5)
	c:RegisterEffect(e5)
end
function c27182808.xfilter(c)
	return c:IsSetCard(0x2c2)
end
function c27182808.ofilter1(c)
	return c:IsCode(27182801)
end
function c27182808.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c27182808.ofilter1,1,nil)
		and c:IsXyzSummonable(nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(27182808,0)) then
		Duel.XyzSummon(tp,c,nil)
	end
end
function c27182808.tg2(e,c)
	return not c:IsSetCard(0x2c2)
end
function c27182808.val4(e,re,tp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local att=0
	local tc=og:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetOriginalAttribute())
		tc=og:GetNext()
	end
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER)
		and bit.band(att,rc:GetOriginalAttribute())~=0
end
function c27182808.tfilter5(c)
	return c:IsSetCard(0x2c2)
		and (c:IsFaceup()
			or c:IsLocation(LOCATION_GRAVE))
		and c:IsAbleToHand()
end
function c27182808.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
			and c27182808.tfilter5(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27182808.tfilter5,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27182808.tfilter5,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27182808.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end