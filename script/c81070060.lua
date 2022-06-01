--블루레이디 쇼

function c81070060.initial_effect(c)

	--immune, untaget
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81070060.iutg)
	e1:SetOperation(c81070060.iuop)
	c:RegisterEffect(e1)
	
	--search to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81070060,0))
	e2:SetCategory(CATEGORY_DESTORY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,81070060)
	e2:SetCondition(c81070060.vcn)
	e2:SetTarget(c81070060.vtg)
	e2:SetOperation(c81070060.vop)
	c:RegisterEffect(e2)
end

--immune, untaget
function c81070060.iutgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcaa) and c:GetFlagEffect(81070060)==0
end
function c81070060.iutg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_MZONE)
			and c81070060.iutgfilter(chkc)
			end
	if chk==0 then return
				Duel.IsExistingTarget(c81070060.iutgfilter,tp,LOCATION_MZONE,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81070060.iutgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c81070060.iuop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(81070060)==0 then
			tc:RegisterFlagEffect(81070060,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(81070060,0))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetValue(aux.tgoval)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetCategory(CATEGORY_NEGATE)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetRange(LOCATION_MZONE)
			e2:SetLabelObject(tc)
			e2:SetCondition(c81070060.uncn)
			e2:SetOperation(c81070060.unop)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
function c81070060.uncn(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(81070060)==0 or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(tc)
end
function c81070060.unop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

--return to deck
function c81070060.vcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST)
	and re:IsHasType(0x7e0) and re:GetHandler():IsSetCard(0xcaa)
end
function c81070060.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c81070060.vtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsDestructable() and chkc:IsOnField() and c8253.filter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81070060.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c81070060.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTORY,g,1,0,0)
end
function c81070060.vop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if tg:IsRelateToEffect(e) and Duel.Destroy(tg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
