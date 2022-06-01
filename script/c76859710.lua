--틴즈 프로세스 - 아즈사
function c76859710.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetOperation(c76859710.op0)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c76859710.con1)
	e1:SetOperation(c76859710.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,76859710)
	e2:SetCondition(c76859710.con2)
	e2:SetCost(c76859710.cost2)
	e2:SetTarget(c76859710.tar2)
	e2:SetOperation(c76859710.op2)
	c:RegisterEffect(e2)
end
function c76859710.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_COST) and re and re:IsActiveType(TYPE_MONSTER) and not c:IsReason(REASON_RETURN) then
		c:RegisterFlagEffect(76859710,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,0)
	end
end
function c76859710.nfil1(c,ft)
	return c:IsSetCard(0x2c0) and c:IsAbleToHandAsCost() and not c:IsCode(76859710) and (ft>0 or c:GetSequence()<5)
end
function c76859710.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c76859710.nfil1,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c76859710.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859710.nfil1,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoHand(g,nil,REASON_COST)
	Duel.ConfirmCards(1-tp,g)
end
function c76859710.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(76859710)>0
end
function c76859710.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c76859710.tfil2(c,e,tp)
	return c:IsSetCard(0x2c0) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c76859710.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ckhc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c76859710.tfil2(chkc,e,tp)
	end
	if chk==0 then
		return ft>0
			and Duel.IsExistingTarget(c76859710.tfil2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	local ct=ft
	if ct>2 then
		ct=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c76859710.tfil2,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c76859710.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>ft then
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end