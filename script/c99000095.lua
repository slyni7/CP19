--Á×Àº ÀÚ¸¦ À§ÇÑ ½Ç¸Á
--µ¥·¹´Ô º¸°í½Í¾î¿ä ;¤µ;
local m=99000095
local cm=_G["c"..m]
function cm.initial_effect(c)
	--trap act in hand
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(ea)
	--act in set turn
	local eb=ea:Clone()
	eb:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	eb:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(eb)
	--immune
	local ec=ea:Clone()
	ec:SetCode(EFFECT_IMMUNE_EFFECT)
	ec:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ec:SetValue(cm.efilter)
	c:RegisterEffect(ec)
	--0
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_PZONE)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	--1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,6))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_PZONE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,7))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_PZONE)
	e2:SetTarget(cm.ttarget)
	e2:SetOperation(cm.toperation)
	c:RegisterEffect(e2)
	--3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,8))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_PZONE)
	e3:SetTarget(cm.tttarget)
	e3:SetOperation(cm.ttoperation)
	c:RegisterEffect(e3)
	if not SpinelTable then SpinelTable={} end
	table.insert(SpinelTable,e1)
	table.insert(SpinelTable,e2)
	table.insert(SpinelTable,e3)
	table.insert(UnlimitChain,e1)
	table.insert(UnlimitChain,e2)
	table.insert(UnlimitChain,e3)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoExtraP(e:GetHandler(),nil,0,REASON_RULE)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,e:GetHandler())
	local tc=g:GetFirst()
	Duel.SetChainLimit(cm.chlimit)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetFirstTarget()
	if sg:IsRelateToEffect(e) then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3),aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,9))
		if op==0 then
			Duel.Destroy(sg,REASON_EFFECT)
		elseif op==1 then
			sel=Duel.SelectOption(tp,aux.Stringid(m,10),aux.Stringid(m,11))+10
		elseif op==2 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		elseif op==3 then
			sel=Duel.SelectOption(tp,aux.Stringid(m,12),aux.Stringid(m,13))+20
		elseif op==4 then
			sel=Duel.SelectOption(tp,aux.Stringid(m,14),aux.Stringid(m,15))+30
		elseif op==5 then
			Duel.Delete(e,sg)
		else
		end
	end
	e:SetLabel(sel)
	if e:GetLabel()==10 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	elseif e:GetLabel()==11 then
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	elseif e:GetLabel()==20 then
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
	elseif e:GetLabel()==21 then
		Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
	elseif e:GetLabel()==30 then
		Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
	elseif e:GetLabel()==31 then
		Duel.SendtoDeck(sg,1-tp,2,REASON_EFFECT)
	else
	end
end
function cm.ttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.SetChainLimit(cm.chlimit)
end
function cm.toperation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
	if g1:GetCount()>0 then
		local op=0
		if g1:GetCount()>0 then
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3),aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,9))
		end
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.Destroy(sg,REASON_EFFECT)
			end
		elseif op==1 then
			op=Duel.SelectOption(tp,aux.Stringid(m,10),aux.Stringid(m,11))+10
		elseif op==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		elseif op==3 then
			op=Duel.SelectOption(tp,aux.Stringid(m,12),aux.Stringid(m,13))+20
		elseif op==4 then
			op=Duel.SelectOption(tp,aux.Stringid(m,14),aux.Stringid(m,15))+30
		elseif op==5 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.Delete(e,sg)
			end
		else
		end
		if op==10 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		elseif op==11 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
			end
		elseif op==20 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.SendtoHand(sg,tp,REASON_EFFECT)
			end
		elseif op==21 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
			end
		elseif op==30 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
			end
		elseif op==31 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.SendtoDeck(sg,1-tp,2,REASON_EFFECT)
			end
		else
		end
	end
end
function cm.tttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.SetChainLimit(cm.chlimit)
end
function cm.ttoperation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Release(sg,REASON_EFFECT)
end