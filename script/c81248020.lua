--THE CELL - 리뎀프터
function c81248020.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xc84),1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c81248020.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(81248020,0))
	e2:SetCountLimit(1,81248020)
	e2:SetLabelObject(e1)
	e2:SetCondition(c81248020.con2)
	e2:SetTarget(c81248020.tar2)
	e2:SetOperation(c81248020.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetDescription(aux.Stringid(81248020,1))
	e3:SetRange(0x04)
	e3:SetCountLimit(1)
	e3:SetCondition(c81248020.con3)
	e3:SetCost(c81248020.cost3)
	e3:SetTarget(c81248020.tar3)
	e3:SetOperation(c81248020.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetDescription(aux.Stringid(81248020,2))
	e4:SetCountLimit(1,81248020)
	e4:SetCondition(c81248020.con4)
	e4:SetCost(c81248020.cost4)
	e4:SetTarget(c81248020.tar4)
	e4:SetOperation(c81248020.op4)
	c:RegisterEffect(e4)
end
function c81248020.vfil1(c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0xc84)
end
function c81248020.val1(e,c)
	local ct=c:GetMaterial():FilterCount(c81248020.vfil1,nil)
	e:SetLabel(ct)
end
function c81248020.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and te:GetLabel()>0
end
function c81248020.tfil2(c)
	return c:IsSetCard(0xc84) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c81248020.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81248020.tfil2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c81248020.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c81248020.tfil2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c81248020.con3(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c81248020.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81248020.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then
		return not rc:IsRelateToEffect(re) or rc:IsAbleToRemove()
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c81248020.op3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c81248020.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function c81248020.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c81248020.tfil4(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0xc84) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToDeckAsCost()) then
		return false
	end
	local m=_G["c"..c:GetCode()]
	if not m then
		return false
	end
	local te=m.second_effect
	if not te then
		return false
	end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c81248020.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then
			return false
		end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c81248020.tfil4,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c81248020.tfil4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	local m=_G["c"..tc:GetCode()]
	local te=m.second_effect
	local tg=te:GetTarget()
	if tg then
		tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	Duel.SetChainLimit(c81248020.clim4)
end
function c81248020.clim4(e,ep,tp)
	local c=e:GetHandler()
	return tp==ep or not c:IsType(TYPE_SPELL)
end
function c81248020.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local m=_G["c"..tc:GetCode()]
	local te=m.second_effect
	local op=te:GetOperation()
	if op then
		op(e,tp,eg,ep,ev,re,r,rp)
	end
end