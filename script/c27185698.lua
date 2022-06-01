--세페르의 다원마도서
function c27185698.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,27185698+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c27185698.con2)
	e2:SetCost(c27185698.cost2)
	e2:SetTarget(c27185698.tg2)
	e2:SetOperation(c27185698.op2)
	c:RegisterEffect(e2)
end
function c27185698.nfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c27185698.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27185698.nfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c27185698.cfilter2(c)
	return c:IsSetCard(0x306e) and not c:IsPublic()
end
function c27185698.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c27185698.cfilter2,tp,LOCATION_HAND,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c27185698.cfilter2,tp,LOCATION_HAND,0,1,1,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c27185698.tfilter2(c)
	return c:IsSetCard(0x306e) and c:GetCode()~=27185698 and c:IsType(TYPE_SPELL) and c:CheckActivateEffect(true,true,false)~=nil and c:GetCode()~=27189799
end
function c27185698.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(te,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27185698.tfilter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c27185698.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	local te=tc:CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	local tg=te:GetTarget()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then
		tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c27185698.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	if tc:IsRelateToEffect(e) then
		local tpe=tc:GetType()
		if c:IsRelateToEffect(e) then
			if bit.band(tpe,TYPE_CONTINUOUS+TYPE_FIELD+EFFECT_TYPE_EQUIP)>0 then
				c:CancelToGrave()
				local code=tc:GetCode()
				c:CopyEffect(code,RESET_EVENT+0x1fe0000,0)
			end
			if bit.band(tpe,TYPE_FIELD)>0 then
				local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
				end
				Duel.MoveSequence(c,5)
			end
		end
		local op=te:GetOperation()
		if op then
			op(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end