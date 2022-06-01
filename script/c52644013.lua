--스타폴 이오노스피어
function c52644013.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--암석족이면 파괴 X
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c52644013.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--파괴
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(52644013,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,52644013)
	e3:SetCondition(c52644013.descon)
	e3:SetTarget(c52644013.dstg)
	e3:SetOperation(c52644013.dsop)
	c:RegisterEffect(e3)
	--종족바꾸기
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(52644013,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c52644013.cost)
	e4:SetTarget(c52644013.chtg)
	e4:SetOperation(c52644013.chop)
	c:RegisterEffect(e4)
	--스탠바이 암석
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(52644009,2))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetTarget(c52644013.swtg)
	e4:SetOperation(c52644013.swop)
	c:RegisterEffect(e4)
end
function c52644013.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRace(RACE_PYRO)
end
function c52644013.indcon(e)
	return e:GetHandler():IsRace(RACE_ROCK)
end
function c52644013.costfilter(c)
	return c:IsSetCard(0x5f4) and c:IsAbleToRemoveAsCost()
end
function c52644013.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(52644013,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c52644013.dsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(tc:GetLevel()*100)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(tc:GetLevel()*100)
		tc:RegisterEffect(e1)
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then 
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c52644013.swtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsRace(RACE_ROCK) end
end
function c52644013.swop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(RACE_ROCK)
		c:RegisterEffect(e1)
	end
end
function c52644013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c52644013.costfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.GetFlagEffect(tp,52644013)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c52644013.costfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,52644013,RESET_CHAIN,0,1)
end
function c52644013.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRace(RACE_ROCK) or e:GetHandler():IsRace(RACE_PYRO) end
end
function c52644013.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsRace(RACE_PYRO) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(RACE_ROCK)
		c:RegisterEffect(e1)
	elseif c:IsFaceup() and c:IsRelateToEffect(e) and c:IsRace(RACE_ROCK) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(RACE_PYRO)
		c:RegisterEffect(e2)
	end
end