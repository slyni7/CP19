--스피넬라 판타지아
local m=99000355
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,99000355)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--activity check
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
	--act qp in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc13))
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.actcost)
	e3:SetTarget(cm.acttg)
	e3:SetOperation(cm.actop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.actcost)
	e4:SetCondition(cm.actcon)
	e4:SetTarget(cm.acttg)
	e4:SetOperation(cm.actop)
	c:RegisterEffect(e4)
	--KR Spinel
	local e99=Effect.CreateEffect(c)
	e99:SetDescription(aux.Stringid(m,2))
	e99:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e99:SetType(EFFECT_TYPE_QUICK_O)
	e99:SetCode(EVENT_FREE_CHAIN)
	e99:SetRange(LOCATION_MZONE)
	e99:SetCountLimit(1,m+1000+EFFECT_COUNT_CODE_DUEL)
	e99:SetCondition(cm.spinel_condition)
	e99:SetTarget(cm.spinel_target)
	e99:SetOperation(cm.spinel_operation)
	c:RegisterEffect(e99)
	if not cm.global_flag then
		cm.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(aux.chainreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(cm.regop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():GetFlagEffect(1)>0 then
		for i=1,15 do
			if rc:IsCode(99000355+i) then
				Duel.RegisterFlagEffect(rp,99000335+rc:GetCode()+10000,0,0,0)
			end
		end
	end
end
function cm.spinel_condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99000335+99000356+10000)~=0 and Duel.GetFlagEffect(tp,99000335+99000357+10000)~=0 and Duel.GetFlagEffect(tp,99000335+99000358+10000)~=0
		and Duel.GetFlagEffect(tp,99000335+99000359+10000)~=0 and Duel.GetFlagEffect(tp,99000335+99000360+10000)~=0 and Duel.GetFlagEffect(tp,99000335+99000361+10000)~=0
		and Duel.GetFlagEffect(tp,99000335+99000362+10000)~=0 and Duel.GetFlagEffect(tp,99000335+99000363+10000)~=0 and Duel.GetFlagEffect(tp,99000335+99000364+10000)~=0
		and Duel.GetFlagEffect(tp,99000335+99000365+10000)~=0 and Duel.GetFlagEffect(tp,99000335+99000366+10000)~=0 and Duel.GetFlagEffect(tp,99000335+99000367+10000)~=0
		and Duel.GetFlagEffect(tp,99000335+99000368+10000)~=0 and Duel.GetFlagEffect(tp,99000335+99000369+10000)~=0 and Duel.GetFlagEffect(tp,99000335+99000370+10000)~=0
end
function cm.spinel_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function cm.spinel_operation(e,tp,eg,ep,ev,re,r,rp)
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
	local youandi=Duel.SelectOption(tp,aux.Stringid(99000094,1),aux.Stringid(99000094,2),aux.Stringid(99000094,3))
	if youandi==0 then
		if checktoken:IsType(TYPE_MONSTER) then
			op=Duel.SelectOption(tp,aux.Stringid(99000099,0),aux.Stringid(99000099,1),aux.Stringid(99000099,2),aux.Stringid(99000099,3))+1
		end
		if checktoken:IsType(TYPE_SPELL+TYPE_TRAP) then
			op=Duel.SelectOption(tp,aux.Stringid(99000099,5),aux.Stringid(99000099,1),aux.Stringid(99000099,2))+10
		end
	elseif youandi==1 then
		if checktoken:IsType(TYPE_MONSTER) then
			op=Duel.SelectOption(tp,aux.Stringid(99000099,6),aux.Stringid(99000099,7),aux.Stringid(99000099,8),aux.Stringid(99000099,9))+50
		end
		if checktoken:IsType(TYPE_SPELL+TYPE_TRAP) then
			op=Duel.SelectOption(tp,aux.Stringid(99000099,11),aux.Stringid(99000099,7),aux.Stringid(99000099,8))+60
		end
	end
	--
	until op==1 or op==2 or op==3 or op==4 or op==10 or op==11 or op==12
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
				op=Duel.SelectOption(tp,aux.Stringid(99000099,12),aux.Stringid(99000099,13))+20
			end
		elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			op=Duel.SelectOption(tp,aux.Stringid(99000099,12),aux.Stringid(99000099,13))+20
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
		op=Duel.SelectOption(tp,aux.Stringid(99000099,12),aux.Stringid(99000099,13))+30
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
function cm.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ((Duel.GetTurnPlayer()==tp and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)>2)
	or (Duel.GetTurnPlayer()~=tp and Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)>0))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m+10000)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	e:GetHandler():RegisterFlagEffect(m+10000,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.spell_filter(c)
	return c:IsSetCard(0xc13) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spell_filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.spell_filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL)
end
function cm.cfilter(c,tp,eg,ep,ev,re,r,rp,chain)
	return c:IsSetCard(0xc13) and c:IsType(TYPE_SPELL) and cm.actfilter(c,tp,eg,ep,ev,re,r,rp,chain)
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
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local chain=Duel.GetCurrentChain()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,tp,eg,ep,ev,re,r,rp,chain) end
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local chain=Duel.GetCurrentChain()-1
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,tp,eg,ep,ev,re,r,rp,chain) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp,eg,ep,ev,re,r,rp,chain)
	if #g>0 then
		local tc=g:GetFirst()
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
			if (tpe&TYPE_FIELD)~=0 then
				local fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
				if Duel.IsDuelType(DUEL_OBSOLETE_RULING) then
					if fc then Duel.Destroy(fc,REASON_RULE) end
					fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
					if fc and Duel.Destroy(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
				else
					fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
					if fc and Duel.SendtoGrave(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
				end
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			if (tpe&TYPE_TRAP+TYPE_FIELD)==TYPE_TRAP+TYPE_FIELD then
				Duel.MoveSequence(tc,5)
			end
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			if (tpe&TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
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
		end
	end
end