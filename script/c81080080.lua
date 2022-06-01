--81080080

function c81080080.initial_effect(c)

	--met
	c:EnableReviveLimit()
	c:SetSPSummonOnce(81080080)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcab),4,2)
	
	--sec
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81080080.sccn)
	e1:SetTarget(c81080080.sctg)
	e1:SetOperation(c81080080.scop)
	c:RegisterEffect(e1)
	
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81080080,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCost(c81080080.co2)
	e2:SetTarget(c81080080.tg2)
	e2:SetOperation(c81080080.op2)
	c:RegisterEffect(e2)
	
	--neg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81080080,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c81080080.ngcn)
	e3:SetTarget(c81080080.ngtg)
	e3:SetOperation(c81080080.ngop)
	c:RegisterEffect(e3)
	
end

--sec
function c81080080.sccn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c81080080.sctgfilter(c)
	return c:IsSetCard(0xcab) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function c81080080.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81080080.sctgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81080080.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81080080.sctgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--equip
function c81080080.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81080080.tfil0(c,tp)
	return c:CheckUniqueOnField(tp) and not c:IsForbidden()
	and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcab)
end
function c81080080.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c81080080.tfil0,tp,LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c81080080.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not tc:IsRelateToEffect(e) or tc:IsFacedown() then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tg=Duel.SelectMatchingCard(tp,c81080080.tfil0,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tg then
		Duel.Equip(tp,tg,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(c81080080.val)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e1)
	end
end
function c81080080.val(e,c)
	return c==e:GetLabelObject()
end

--neg
function c81080080.ngcnfilter(c)
	return c:IsType(TYPE_EQUIP)
end
function c81080080.ngcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81080080.ngcnfilter,tp,LOCATION_SZONE,0,1,nil)
	and ep~=tp
end
function c81080080.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81080080.ngop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

