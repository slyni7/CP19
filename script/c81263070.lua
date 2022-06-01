--궤의 조표
function c81263070.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,81263070)
	e2:SetTarget(c81263070.tg1)
	e2:SetOperation(c81263070.op1)
	c:RegisterEffect(e2)
	
	--회피
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,81263071)
	e3:SetTarget(c81263070.tg3)
	e3:SetOperation(c81263070.op3)
	e3:SetValue(c81263070.va3)
	c:RegisterEffect(e3)
	
	--내성
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,81263072)
	e4:SetCondition(c81263070.cn4)
	e4:SetOperation(c81263070.op4)
	c:RegisterEffect(e4)
end

--서치
function c81263070.filter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc95) and c:IsType(TYPE_MONSTER)
end
function c81263070.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81263070.filter0,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c81263070.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c81263070.filter0,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(g2,REASON_EFFECT)
		end
	end
end

--회피
function c81263070.filter1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsControler(tp) and c:IsLocation(LOCATION_SZONE)
	and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c81263070.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c81263070.filter1,1,e:GetHandler(),tp)
	end	
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c81263070.va3(e,c)
	return c81263070.filter1(c,e:GetHandlerPlayer())
end
function c81263070.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end

--내성
function c81263070.cn4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_FZONE)
end
function c81263070.op4(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_FIELD)
   e1:SetCode(EFFECT_CANNOT_INACTIVATE)
   e1:SetValue(c81263070.ova4)
   e1:SetReset(RESET_PHASE+PHASE_END)
   Duel.RegisterEffect(e1,tp)
   local e2=e1:Clone()
   e2:SetCode(EFFECT_CANNOT_DISEFFECT)
   Duel.RegisterEffect(e2,tp)
end
function c81263070.ova4(e,ct)
   local p=e:GetHandler():GetControler()
   local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
   return p==tp and te:GetHandler():IsRace(RACE_WYRM)
end


