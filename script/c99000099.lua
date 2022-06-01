--KR Spinel
local m=99000099
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
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_SINGLE)
	ec:SetCode(EFFECT_IMMUNE_EFFECT)
	ec:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ec:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_PZONE)
	ec:SetValue(cm.efilter)
	c:RegisterEffect(ec)
	--King God Emperor General Chungmugong Majesty	
	local ed=Effect.CreateEffect(c)	
	ed:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ed:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ed:SetCode(EVENT_PREDRAW)
	ed:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	ed:SetRange(0xf7)
	ed:SetOperation(cm.op)
	c:RegisterEffect(ed)
	--send EX
	local ee=ed:Clone()
	ee:SetCode(EVENT_ADJUST)
	ee:SetCountLimit(999)
	ee:SetRange(LOCATION_PZONE)
	ee:SetOperation(cm.exop)
	c:RegisterEffect(ee)
	--Enjoyable Creeeeeation Time
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99000300,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_PZONE)
	e1:SetTarget(cm.chainlim)
	e1:SetOperation(cm.createop)
	c:RegisterEffect(e1)
	--LP Ma Jae-Yoon
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(99000300,1))
	e2:SetOperation(cm.lpoperation)
	c:RegisterEffect(e2)
	--Ja Warudo! Tokio Tomare!
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(99000300,2))
	e3:SetHintTiming(0,TIMING_DRAW_PHASE)
	e3:SetCondition(cm.turncon)
	e3:SetOperation(cm.turnoperation)
	c:RegisterEffect(e3)
	--Hacking to the Gate
	local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(99000300,3))
	e4:SetTarget(cm.summontg)
	e4:SetOperation(cm.summonop)
	c:RegisterEffect(e4)
	if not SpinelTable then SpinelTable={} end
	table.insert(SpinelTable,e1)
	table.insert(SpinelTable,e2)
	table.insert(SpinelTable,e3)
	table.insert(SpinelTable,e4)
	table.insert(UnlimitChain,e1)
	table.insert(UnlimitChain,e2)
	table.insert(UnlimitChain,e3)
	table.insert(UnlimitChain,e4)
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_CARD,0,m)
	for i=0,4 do
		local token=Duel.CreateToken(tp,99000094+i)
		if token then
      			Duel.SendtoExtraP(token,nil,0,REASON_RULE)
		end
	end
	Duel.SendtoExtraP(e:GetHandler(),nil,0,REASON_RULE)
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoExtraP(e:GetHandler(),nil,0,REASON_RULE)
end
function cm.chainlim(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.actfilter(c,tp,eg,ep,ev,re,r,rp,chain)
	if not c:IsType(TYPE_FIELD) and Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
	local te=c:GetActivateEffect()
	if not te then return false end
	if c:IsHasEffect(EFFECT_CANNOT_TRIGGER) then return false end
	local pre={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	if pre[1] then
		for i,eff in ipairs(pre) do
			local prev=eff:GetValue()
			if type(prev)~='function' or prev(eff,te,tp) then return false end
		end
	end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	if te:GetCode()==EVENT_CHAINING then
		if chain<=0 then return false end
		local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local tc=te2:GetHandler()
		local g=Group.FromCards(tc)
		local p=tc:GetControler()
		return (not condition or condition(te,tp,g,p,chain,te2,REASON_EFFECT,p)) and (not cost or cost(te,tp,g,p,chain,te2,REASON_EFFECT,p,0)) 
			and (not target or target(te,tp,g,p,chain,te2,REASON_EFFECT,p,0))
	elseif te:GetCode()==EVENT_FREE_CHAIN then
		return (not condition or condition(te,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(te,tp,eg,ep,ev,re,r,rp,0))
			and (not target or target(te,tp,eg,ep,ev,re,r,rp,0))
	else
		local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		return res and (not condition or condition(te,tp,teg,tep,tev,tre,tr,trp)) and (not cost or cost(te,tp,teg,tep,tev,tre,tr,trp,0))
			and (not target or target(te,tp,teg,tep,tev,tre,tr,trp,0))
	end
end
function cm.createop(e,tp,eg,ep,ev,re,r,rp)
	--
	local spos=POS_FACEUP+POS_FACEDOWN
	--
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local tk=0
	repeat
		tk=Duel.AnnounceCard(tp)
		Duel.Hint(HINT_CARD,0,tk)
		local checktoken=Duel.CreateToken(tp,tk)
	--
	op=0
	local youandi=Duel.SelectOption(tp,aux.Stringid(99000094,1),aux.Stringid(99000094,2),aux.Stringid(99000094,3),aux.Stringid(99000094,4))
	if youandi==0 then
		if checktoken:IsType(TYPE_MONSTER) then
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))+1
		end
		if checktoken:IsType(TYPE_SPELL+TYPE_TRAP) then
			op=Duel.SelectOption(tp,aux.Stringid(m,5),aux.Stringid(m,1),aux.Stringid(m,2))+10
		end
	elseif youandi==1 then
		if checktoken:IsType(TYPE_MONSTER) then
			op=Duel.SelectOption(tp,aux.Stringid(m,6),aux.Stringid(m,7),aux.Stringid(m,8),aux.Stringid(m,9))+50
		end
		if checktoken:IsType(TYPE_SPELL+TYPE_TRAP) then
			op=Duel.SelectOption(tp,aux.Stringid(m,11),aux.Stringid(m,7),aux.Stringid(m,8))+60
		end
	end
	--
	until youandi==3 or op==1 or op==2 or op==3 or op==4 or op==10 or op==11 or op==12
		or op==50 or op==51 or op==52 or op==53 or op==60 or op==61 or op==62
	local token=Duel.CreateToken(tp,tk)
	local oppotoken=Duel.CreateToken(1-tp,tk)
	-- Monster Card
	if op==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.MoveToField(token,tp,tp,LOCATION_MZONE,spos,true)
	--
	elseif op==2 then
		Duel.SendtoHand(token,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,token)
	--
	elseif op==3 then
		Duel.SendtoDeck(token,tp,0,REASON_RULE)
		if token:IsLocation(LOCATION_EXTRA) then
			Duel.ConfirmCards(1-tp,token)
		else
			Duel.ConfirmDecktop(tp,1)
		end
	--
	elseif op==4 then
		if Duel.GetLocationCountFromEx(tp)>0 then
			if token:IsType(TYPE_PENDULUM) then
				Duel.SendtoExtraP(token,tp,0,REASON_RULE)
				Duel.MoveToField(token,tp,tp,LOCATION_MZONE,spos,true)
			elseif token:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+0x40003000+0x40000000+0x10000000) then
				Duel.SendtoDeck(token,tp,0,REASON_RULE)
				Duel.MoveToField(token,tp,tp,LOCATION_MZONE,spos,true)
			else
				op=Duel.SelectOption(tp,aux.Stringid(m,12),aux.Stringid(m,13))+20
			end
		elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			op=Duel.SelectOption(tp,aux.Stringid(m,12),aux.Stringid(m,13))+20
		end
	--
	elseif op==50 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.MoveToField(oppotoken,tp,1-tp,LOCATION_MZONE,spos,true)
	--
	elseif op==51 then
		Duel.SendtoHand(oppotoken,1-tp,REASON_RULE)
		Duel.ConfirmCards(tp,oppotoken)
	--
	elseif op==52 then
		Duel.SendtoDeck(oppotoken,1-tp,0,REASON_RULE)
		if oppotoken:IsLocation(LOCATION_EXTRA) then
			Duel.ConfirmCards(tp,oppotoken)
		else
			Duel.ConfirmDecktop(1-tp,1)
		end
	--
	elseif op==53 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		op=Duel.SelectOption(tp,aux.Stringid(m,12),aux.Stringid(m,13))+30
	else
	end
	--Extra Monster Zone
	if op==20 then
		Duel.MoveToField(token,tp,tp,LOCATION_MZONE,spos,true)
		Duel.MoveSequence(token,5)
	--
	elseif op==21 then
		Duel.MoveToField(token,tp,tp,LOCATION_MZONE,spos,true)
		Duel.MoveSequence(token,6)
	--
	elseif op==30 then
		Duel.MoveToField(oppotoken,tp,1-tp,LOCATION_MZONE,spos,true)
		Duel.MoveSequence(oppotoken,6)
	--
	elseif op==31 then
		Duel.MoveToField(oppotoken,tp,1-tp,LOCATION_MZONE,spos,true)
		Duel.MoveSequence(oppotoken,5)
	end
	-- Spell & Trap Card
	if op==10 then
		local tc=token
		local chain=Duel.GetCurrentChain()-1
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
       		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		if not te then return end
		local con=te:GetCondition()
		local co=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		if cm.actfilter(tc,tp,eg,ep,ev,re,r,rp,chain) then
			Duel.ClearTargetCard()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			if bit.band(tpe,TYPE_FIELD)~=0 then
				local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			if bit.band(tpe,TYPE_TRAP+TYPE_FIELD)==TYPE_TRAP+TYPE_FIELD then
				Duel.MoveSequence(tc,5)
			end
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
				tc:CancelToGrave(false)
			end
			if te:GetCode()==EVENT_CHAINING then
				local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
				local tc=te2:GetHandler()
				local g=Group.FromCards(tc)
				local p=tc:GetControler()
				if co then co(te,tp,g,p,chain,te2,REASON_EFFECT,p,1) end
				if tg then tg(te,tp,g,p,chain,te2,REASON_EFFECT,p,1) end
			elseif te:GetCode()==EVENT_FREE_CHAIN then
				if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
				if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			else
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
				if co then co(te,tp,teg,tep,tev,tre,tr,trp,1) end
				if tg then tg(te,tp,teg,tep,tev,tre,tr,trp,1) end
			end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				local etc=g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=g:GetNext()
				end
			end
			Duel.BreakEffect()
			tc:SetStatus(STATUS_ACTIVATED,true)
			if not tc:IsDisabled() then
				if te:GetCode()==EVENT_CHAINING then
					local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
					local tc=te2:GetHandler()
					local g=Group.FromCards(tc)
					local p=tc:GetControler()
					if op then op(te,tp,g,p,chain,te2,REASON_EFFECT,p) end
				elseif te:GetCode()==EVENT_FREE_CHAIN then
					if op then op(te,tp,eg,ep,ev,re,r,rp) end
				else
					local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
					if op then op(te,tp,teg,tep,tev,tre,tr,trp) end
				end
			else
				--insert negated animation here
			end
			Duel.RaiseEvent(Group.CreateGroup(tc),EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
			if g and tc:IsType(TYPE_EQUIP) and not tc:GetEquipTarget() then
				Duel.Equip(tp,tc,g:GetFirst())
			end
			tc:ReleaseEffectRelation(te)
			if etc then	
				etc=g:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc=g:GetNext()
				end
			end
	else
		Duel.SendtoHand(token,tp,REASON_RULE)
		Duel.ConfirmCards(1-tp,token)
	end
	--
	elseif op==11 then
		Duel.SendtoHand(token,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,token)
	--
	elseif op==12 then
		Duel.SendtoDeck(token,tp,0,REASON_EFFECT)
		Duel.ConfirmDecktop(tp,1)
	--
	elseif op==60 then
		local tc=oppotoken
		local chain=Duel.GetCurrentChain()-1
		local tp=1-tp
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
       		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		if not te then return end
		local con=te:GetCondition()
		local co=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		if cm.actfilter(tc,tp,eg,ep,ev,re,r,rp,chain) then
			Duel.ClearTargetCard()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			if bit.band(tpe,TYPE_FIELD)~=0 then
				local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			if bit.band(tpe,TYPE_TRAP+TYPE_FIELD)==TYPE_TRAP+TYPE_FIELD then
				Duel.MoveSequence(tc,5)
			end
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
				tc:CancelToGrave(false)
			end
			if te:GetCode()==EVENT_CHAINING then
				local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
				local tc=te2:GetHandler()
				local g=Group.FromCards(tc)
				local p=tc:GetControler()
				if co then co(te,tp,g,p,chain,te2,REASON_EFFECT,p,1) end
				if tg then tg(te,tp,g,p,chain,te2,REASON_EFFECT,p,1) end
			elseif te:GetCode()==EVENT_FREE_CHAIN then
				if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
				if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			else
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
				if co then co(te,tp,teg,tep,tev,tre,tr,trp,1) end
				if tg then tg(te,tp,teg,tep,tev,tre,tr,trp,1) end
			end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				local etc=g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=g:GetNext()
				end
			end
			Duel.BreakEffect()
			tc:SetStatus(STATUS_ACTIVATED,true)
			if not tc:IsDisabled() then
				if te:GetCode()==EVENT_CHAINING then
					local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
					local tc=te2:GetHandler()
					local g=Group.FromCards(tc)
					local p=tc:GetControler()
					if op then op(te,tp,g,p,chain,te2,REASON_EFFECT,p) end
				elseif te:GetCode()==EVENT_FREE_CHAIN then
					if op then op(te,tp,eg,ep,ev,re,r,rp) end
				else
					local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
					if op then op(te,tp,teg,tep,tev,tre,tr,trp) end
				end
			else
				--insert negated animation here
			end
			Duel.RaiseEvent(Group.CreateGroup(tc),EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
			if g and tc:IsType(TYPE_EQUIP) and not tc:GetEquipTarget() then
				Duel.Equip(tp,tc,g:GetFirst())
			end
			tc:ReleaseEffectRelation(te)
			if etc then	
				etc=g:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc=g:GetNext()
				end
			end
	else
		Duel.SendtoHand(oppotoken,tp,REASON_RULE)
		Duel.ConfirmCards(1-tp,oppotoken)
	end
	--
	elseif op==61 then
		Duel.SendtoHand(oppotoken,1-tp,REASON_RULE)
		Duel.ConfirmCards(tp,oppotoken)
	--
	elseif op==62 then
		Duel.SendtoDeck(oppotoken,1-tp,0,REASON_EFFECT)
		Duel.ConfirmDecktop(1-tp,1)
	else
	end
end
function cm.lpoperation(e,tp,eg,ep,ev,re,r,rp)
	local val=0
	local ct=math.floor(50000/1000)
	local t={}
	for i=1,ct do
		t[i]=i*1000
	end
	val=Duel.AnnounceNumber(tp,table.unpack(t))
	op=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,10),aux.Stringid(99000094,4))+20
	if op==20 then
		Duel.SetLP(tp,val)
	elseif op==21 then
		Duel.SetLP(1-tp,val)
	else
	end
end
function cm.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.turnoperation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SKIP_SP)
        Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SKIP_M1)
        Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_SKIP_BP)
        Duel.RegisterEffect(e4,tp)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_SKIP_M2)
        Duel.RegisterEffect(e5,tp)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CANNOT_BP)
        Duel.RegisterEffect(e6,tp)
	local e7=e1:Clone()
	e7:SetCode(EFFECT_CANNOT_M2)
        Duel.RegisterEffect(e7,tp)
	local e8=e1:Clone()
	e8:SetCode(EFFECT_CANNOT_EP)
        Duel.RegisterEffect(e8,tp)
end
function cm.summontg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.summonop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		op=Duel.SelectOption(tp,aux.Stringid(m,14),aux.Stringid(m,15),aux.Stringid(99000094,4))+40
		if op==40 then
			Duel.RaiseEvent(tc,EVENT_SUMMON_SUCCESS,e,REASON_EFFECT,tp,tc:GetControler(),ev)
			Duel.RaiseSingleEvent(tc,EVENT_SUMMON_SUCCESS,e,REASON_EFFECT,tp,tc:GetControler(),ev)
			tc:SetStatus(STATUS_SUMMON_TURN,true)
		elseif op==41 then
			Duel.RaiseEvent(tc,EVENT_SPSUMMON_SUCCESS,e,REASON_EFFECT,tp,tc:GetControler(),ev)
			Duel.RaiseSingleEvent(tc,EVENT_SPSUMMON_SUCCESS,e,REASON_EFFECT,tp,tc:GetControler(),ev)
			tc:SetStatus(STATUS_SPSUMMON_TURN,true)
		else
		end
	end
end