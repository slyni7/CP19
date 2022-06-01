--죠노우치 파이어!
local m=99000094
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
	--dice
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ed:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ed:SetRange(LOCATION_EXTRA)
	ed:SetCode(EVENT_TOSS_DICE_NEGATE)
	ed:SetOperation(cm.diceop)
	c:RegisterEffect(ed)
	--coin
	local ee=Effect.CreateEffect(c)
	ee:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ee:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ee:SetRange(LOCATION_EXTRA)
	ee:SetCode(EVENT_TOSS_COIN_NEGATE)
	ee:SetOperation(cm.coinop)
	c:RegisterEffect(ee)
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
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
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
	if not SpinelTable then SpinelTable={} end
	table.insert(SpinelTable,e1)
	table.insert(SpinelTable,e2)
	table.insert(UnlimitChain,e1)
	table.insert(UnlimitChain,e2)
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
function cm.diceop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if cm[0]~=cid and Duel.SelectYesNo(tp,aux.Stringid(m,8)) then
	Duel.Hint(HINT_CARD,0,m)
	local res=0
	local ct=math.floor(60/1)
	local t={}
	for i=1,ct do
		t[i]=i*1
	end
	val=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.SetDiceResult(val)
	cm[0]=cid
	end
end
function cm.coinop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if cm[0]~=cid and Duel.SelectYesNo(tp,aux.Stringid(m,8)) then
		Duel.Hint(HINT_CARD,0,m)
		local res=0
		res=1-Duel.SelectOption(tp,60,61)
		Duel.SetCoinResult(res)
		cm[0]=cid
	end
end
function cm.cfilter(c)
	return not c:IsCode(99000095) and not c:IsCode(99000096) and not c:IsCode(99000097) and not c:IsCode(99000098) and not c:IsCode(99000099)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,LOCATION_HAND+LOCATION_EXTRA,1,e:GetHandler()) end
	Duel.SetChainLimit(cm.chlimit)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,LOCATION_HAND+LOCATION_EXTRA,e:GetHandler())
	if g1:GetCount()>0 then
		local op=0
		if g1:GetCount()>0 then
			op=Duel.SelectOption(tp,aux.Stringid(99000095,0),aux.Stringid(99000095,1),aux.Stringid(99000095,2),aux.Stringid(99000095,3),aux.Stringid(99000095,4),aux.Stringid(99000095,5),aux.Stringid(99000095,9))
		end
		if op==0 then
			Duel.ConfirmCards(tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.Destroy(sg,REASON_EFFECT)
				Duel.ShuffleHand(tp)
				Duel.ShuffleHand(1-tp)
			end
		elseif op==1 then
			op=Duel.SelectOption(tp,aux.Stringid(m,10),aux.Stringid(m,11))+10
		elseif op==2 then
			Duel.ConfirmCards(tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.SendtoGrave(sg,REASON_EFFECT)
				Duel.ShuffleHand(tp)
				Duel.ShuffleHand(1-tp)
			end
		elseif op==3 then
			op=Duel.SelectOption(tp,aux.Stringid(m,12),aux.Stringid(m,13))+20
		elseif op==4 then
			op=Duel.SelectOption(tp,aux.Stringid(m,14),aux.Stringid(m,15))+30
		elseif op==5 then
			Duel.ConfirmCards(tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.Delete(e,sg)
				Duel.ShuffleHand(tp)
				Duel.ShuffleHand(1-tp)
			end
		else
		end
		if op==10 then
			Duel.ConfirmCards(tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
				Duel.ShuffleHand(tp)
				Duel.ShuffleHand(1-tp)
			end
		elseif op==11 then
			Duel.ConfirmCards(tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
				Duel.ShuffleHand(tp)
				Duel.ShuffleHand(1-tp)
			end
		elseif op==20 then
			Duel.ConfirmCards(tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.SendtoHand(sg,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				Duel.ShuffleHand(1-tp)
			end
		elseif op==21 then
			Duel.ConfirmCards(tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
				Duel.ConfirmCards(tp,sg)
				Duel.ShuffleHand(tp)
				Duel.ShuffleHand(1-tp)
			end
		elseif op==30 then
			Duel.ConfirmCards(tp,g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
				Duel.ShuffleHand(tp)
				Duel.ShuffleHand(1-tp)
			end
		elseif op==31 then
			Duel.ConfirmCards(tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			if sg then
				Duel.SendtoDeck(sg,1-tp,2,REASON_EFFECT)
				Duel.ShuffleHand(tp)
				Duel.ShuffleHand(1-tp)
			end
		else
		end
	end
end
function cm.ttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK+LOCATION_REMOVED,LOCATION_DECK+LOCATION_REMOVED,1,e:GetHandler()) end
	Duel.SetChainLimit(cm.chlimit)
end
function cm.toperation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_REMOVED,LOCATION_DECK+LOCATION_REMOVED)
	Duel.ConfirmCards(tp,g1)
	if g1:GetCount()>0 then
		local op=0
		if g1:GetCount()>0 then
			op=Duel.SelectOption(tp,aux.Stringid(99000095,0),aux.Stringid(99000095,1),aux.Stringid(99000095,2),aux.Stringid(99000095,3),aux.Stringid(99000095,4),aux.Stringid(99000095,5),aux.Stringid(99000095,9))
		end
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			Duel.Destroy(sg,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
		elseif op==1 then
			op=Duel.SelectOption(tp,aux.Stringid(m,10),aux.Stringid(m,11))+10
		elseif op==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			Duel.SendtoGrave(sg,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
		elseif op==3 then
			op=Duel.SelectOption(tp,aux.Stringid(m,12),aux.Stringid(m,13))+20
		elseif op==4 then
			op=Duel.SelectOption(tp,aux.Stringid(m,14),aux.Stringid(m,15))+30
		elseif op==5 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			Duel.Delete(e,sg)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
		end
		if op==10 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
		elseif op==11 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
		elseif op==20 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
		elseif op==21 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
			Duel.ConfirmCards(tp,sg)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
		elseif op==30 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
		elseif op==31 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=g1:Select(tp,1,1,e:GetHandler())
			local sg=g:GetFirst()
			Duel.SendtoDeck(sg,1-tp,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
		end
	else
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
	end
end