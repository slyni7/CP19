--匙农肺况目 饭捞每
local m=99000152
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Search
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,m)
	e0:SetTarget(cm.thtg)
	e0:SetOperation(cm.thop)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m+1000)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+2000)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,tp,eg,ep,ev,re,r,rp,chain)
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
function cm.thfilter(c)
	return c:IsSetCard(0xc24) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or cm.cfilter(c,tp,eg,ep,ev,re,r,rp,chain))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local chain=Duel.GetCurrentChain()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tp,eg,ep,ev,re,r,rp,chain) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:GetActivateEffect():IsActivatable(tp)
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
		elseif b1 then op=0
		else op=1 end
		if op==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			local chain=Duel.GetCurrentChain()-1
			if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
       			local tpe=tc:GetType()
			local te=tc:GetActivateEffect()
			if not te then return end
			local con=te:GetCondition()
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			if cm.cfilter(tc,tp,eg,ep,ev,re,r,rp,chain) then
				Duel.ClearTargetCard()
				e:SetCategory(te:GetCategory())
				e:SetProperty(te:GetProperty())
				if bit.band(tpe,TYPE_FIELD)~=0 then
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
			end
		end
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_SZONE)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(99000149,2)) then
			Duel.BreakEffect()
			c:ReleaseEffectRelation(re)
		end
	end
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xc24) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end