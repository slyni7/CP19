--S. Enchanter: 7
function c99970027.initial_effect(c)

	--엑시즈 소환
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd32),4,2,c99970027.ovfilter,aux.Stringid(99970027,0),2,c99970027.xyzop)
	c:EnableReviveLimit()
	
	--서치
	local ey=Effect.CreateEffect(c)
	ey:SetDescription(aux.Stringid(99970027,1))
	ey:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	ey:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ey:SetCode(EVENT_SPSUMMON_SUCCESS)
	ey:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	ey:SetCondition(c99970027.xcon)
	ey:SetTarget(c99970027.xtarget)
	ey:SetOperation(c99970027.xoperation)
	c:RegisterEffect(ey)
	
	--세트
	local ex=Effect.CreateEffect(c)
	ex:SetDescription(aux.Stringid(99970027,2))
	ex:SetCategory(CATEGORY_POSITION)
	ex:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ex:SetType(EFFECT_TYPE_QUICK_O)
	ex:SetRange(LOCATION_MZONE)
	ex:SetCode(EVENT_FREE_CHAIN)
	ex:SetCountLimit(1)
	ex:SetHintTiming(0,0x1e0)
	ex:SetCost(c99970027.setcost)
	ex:SetTarget(c99970027.settg)
	ex:SetOperation(c99970027.setop)
	c:RegisterEffect(ex,false,1)
	
	--오버레이
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970027,3))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c99970027.matcon)
	e1:SetTarget(c99970027.mattg)
	e1:SetOperation(c99970027.matop)
	c:RegisterEffect(e1)
	
end

--엑시즈 소환
function c99970027.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd32) and not c:IsCode(99970027) and c:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_LIGHT)
end
function c99970027.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,99970027)==0 end
	Duel.RegisterFlagEffect(tp,99970027,RESET_PHASE+PHASE_END,0,1)
	return true
end

--서치
function c99970027.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c99970027.xfilter(c)
	return c:IsSetCard(0xd32) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99970027.xtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970027.xfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970027.xoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99970027.xfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--세트
function c99970027.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99970027.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c99970027.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99970027.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99970027.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c99970027.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c99970027.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end


--오버레이
function c99970027.matcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c99970027.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd32)
end
function c99970027.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c99970027.matfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingTarget(c99970027.matfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c99970027.matfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c99970027.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end


