--THE CELL - 레코더
function c81248030.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xc84),1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c81248030.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(81248030,0))
	e2:SetCountLimit(1,81248030)
	e2:SetLabelObject(e1)
	e2:SetCondition(c81248030.con2)
	e2:SetTarget(c81248030.tar2)
	e2:SetOperation(c81248030.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetDescription(aux.Stringid(81248030,1))
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(0x04)
	e3:SetCondition(c81248030.con3)
	e3:SetCost(c81248030.cost3)
	e3:SetTarget(c81248030.tar3)
	e3:SetOperation(c81248030.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_SUMMON)
	e4:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(81248030,2))
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetRange(0x04)
	e4:SetCondition(c81248030.con4)
	e4:SetCost(c81248030.cost3)
	e4:SetTarget(c81248030.tar4)
	e4:SetOperation(c81248030.op4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetDescription(aux.Stringid(81248030,3))
	e6:SetCountLimit(1,81248030)
	e6:SetCondition(c81248030.con6)
	e6:SetCost(c81248030.cost6)
	e6:SetTarget(c81248030.tar6)
	e6:SetOperation(c81248030.op6)
	c:RegisterEffect(e6)
end
function c81248030.vfil1(c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0xc84)
end
function c81248030.val1(e,c)
	local ct=c:GetMaterial():FilterCount(c81248030.vfil1,nil)
	e:SetLabel(ct)
end
function c81248030.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and te:GetLabel()>0
end
function c81248030.tfil2(c)
	return c:IsSetCard(0xc84) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c81248030.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81248030.tfil2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c81248030.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c81248030.tfil2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,2,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c81248030.con3(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev) and rp~=tp
end
function c81248030.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81248030.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c81248030.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c81248030.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and ep~=tp
end
function c81248030.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function c81248030.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c81248030.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function c81248030.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c81248030.tfil6(c,e,tp,eg,ep,ev,re,r,rp)
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
function c81248030.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then
			return false
		end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c81248030.tfil6,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c81248030.tfil6,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	local m=_G["c"..tc:GetCode()]
	local te=m.second_effect
	local tg=te:GetTarget()
	if tg then
		tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	Duel.SetChainLimit(c81248030.clim6)
end
function c81248030.clim6(e,ep,tp)
	local c=e:GetHandler()
	return tp==ep or not c:IsType(TYPE_SPELL)
end
function c81248030.op6(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local m=_G["c"..tc:GetCode()]
	local te=m.second_effect
	local op=te:GetOperation()
	if op then
		op(e,tp,eg,ep,ev,re,r,rp)
	end
end