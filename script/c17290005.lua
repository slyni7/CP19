--파이널 히어로 리얼라이즈
function c17290005.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,17290005)
	e5:SetTarget(c17290005.tg5)
	e5:SetOperation(c17290005.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_RELEASE)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetCountLimit(1,172900050)
	e6:SetTarget(c17290005.tg6)
	e6:SetOperation(c17290005.op6)
	c:RegisterEffect(e6)
end
function c17290005.mat_filter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) or c:IsSetCard(0x8)
end
function c17290005.tfilter5(c)
	return c:IsSetCard(0x2c3) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:CheckActivateEffect(true,true,false)~=nil and c:IsAbleToDeck()
end
function c17290005.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(te,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c17290005.tfilter5,tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(CATEGORY_TODECK)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c17290005.tfilter5,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	local te=tc:CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	local tg=te:GetTarget()
	e:SetProperty(te:GetProperty())
	e:SetCategory(te:GetCategory())
	if tg then
		tg(te,tp,eg,ep,ev,re,r,rp,1)
	end
	local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local cc=cg:GetFirst()
	while cc do
		cc:CreateEffectRelation(te)
		cc=cg:GetNext()
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c17290005.op5(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	if tc:IsRelateToEffect(e) then
		local op=te:GetOperation()
		if op then
			op(te,tp,eg,ep,ev,re,r,rp)
		end
		local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local cc=cg:GetFirst()
		while cc do
			cc:ReleaseEffectRelation(te)
			cc=cg:GetNext()
		end
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c17290005.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
	end
end
function c17290005.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(c:GetLocation())
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	if Duel.GetTurnPlayer()==tp then
		e1:SetLabel(Duel.GetTurnCount())
	else
		e1:SetLabel(Duel.GetTurnCount()-1)
	end
	e1:SetCondition(c17290005.con61)
	e1:SetOperation(c17290005.op61)
	c:RegisterEffect(e1)
end
function c17290005.con61(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	return Duel.GetTurnCount()==ct+2
end
function c17290005.op61(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
	e:Reset()
end