--세상을 만드는 이전의 방법론
local m=112603067
local cm=_G["c"..m]
function cm.initial_effect(c)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_OVERLAY)
	e3:SetCondition(cm.negcon)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_DISABLE_CHAIN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e1:SetCondition(cm.paradigmcon)
	e1:SetTarget(cm.paradigmtg)
	e1:SetOperation(cm.paradigmop)
	c:RegisterEffect(e1)
	--immune
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_IMMUNE_EFFECT)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_OVERLAY)
	e10:SetValue(cm.efilter)
	c:RegisterEffect(e10)
	--cannot disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e5)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE,LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(cm.paradigmcon)
	e2:SetTarget(cm.distarget2)
	c:RegisterEffect(e2)
	--disable effect
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e32:SetCode(EVENT_CHAIN_SOLVING)
	e32:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e32:SetCondition(cm.paradigmcon)
	e32:SetOperation(cm.disop1)
	c:RegisterEffect(e32)
	--disable effect
	local e23=Effect.CreateEffect(c)
	e23:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e23:SetCode(EVENT_CHAIN_ACTIVATING)
	e23:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e23:SetOperation(cm.disop2)
	e23:SetCondition(cm.paradigmcon)
	c:RegisterEffect(e23)
end

--negate
function cm.cfilter1(c)
	return (c:IsType(TYPE_UNION) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0xe7b)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,15,nil)
		and rp==1-tp and (re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))) and Duel.IsChainDisablable(ev)
		and e:GetHandler():GetFlagEffect(m)<=0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,15,nil) then
			Duel.SendtoDeck(rc,nil,-2,REASON_EFFECT)
				local c=e:GetHandler()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetTargetRange(0,LOCATION_ONFIELD)
				e1:SetTarget(cm.distg)
				e1:SetLabelObject(rc)
				e1:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetCondition(cm.discon)
				e2:SetOperation(cm.disop)
				e2:SetLabelObject(rc)
				e2:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e2,tp)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e3:SetCode(EFFECT_CANNOT_ACTIVATE)
				e3:SetTargetRange(0,1)
				e3:SetValue(cm.aclimit)
				e3:SetLabelObject(rc)
				e3:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e3,tp)
			Duel.BreakEffect()
			Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		end
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end

function cm.negop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		local rc=eg
			if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_DECK,0,1,nil) then
				Duel.SendtoDeck(rc,nil,-2,REASON_EFFECT)
				Duel.BreakEffect()
				Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetTarget(cm.distg)
			e1:SetLabelObject(rc)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(cm.discon)
			e2:SetOperation(cm.disop)
			e2:SetLabelObject(rc)
			e2:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_CANNOT_ACTIVATE)
			e3:SetTargetRange(0,1)
			e3:SetValue(cm.aclimit)
			e3:SetLabelObject(rc)
			e3:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e3,tp)
		end
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.aclimit(e,re,tp)
	local c=re:GetHandler()
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end

--remove
function cm.filter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function cm.cfilter2(c)
	return c:IsSetCard(0xe7b) and c:IsType(TYPE_MONSTER)
end
function cm.paradigmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
end
function cm.paradigmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.paradigmop(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
		if e:GetHandler():IsPreviousLocation(LOCATION_HAND) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
	local token=Duel.CreateToken(tp,112501006)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112501007)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112501008)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112501009)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112501010)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local sg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SendtoDeck(sg,nil,-2,REASON_EFFECT)
end

--immune
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

--disable
function cm.distarget2(e,c)
	return not c:IsCode(m)
end
function cm.disop1(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	if re:GetActiveType()==TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP and p~=tp and bit.band(loc,LOCATION_HAND+LOCATION_GRAVE)~=0 then
		Duel.NegateEffect(ev)
	end
end
function cm.disop2(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if (loc==LOCATION_GRAVE or loc==LOCATION_HAND) and not re:GetHandler():IsCode(m) then
		Duel.NegateEffect(ev)
	end
end