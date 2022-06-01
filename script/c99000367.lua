--FINDING_THE_MISSING@SPELL
local m=99000367
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.condition2)
	e3:SetTarget(cm.target2)
	e3:SetOperation(cm.operation2)
	c:RegisterEffect(e3)
end
function cm.ctfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc18) and c:IsControler(tp) and c:GetSummonLocation()==LOCATION_EXTRA
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.ctfilter,1,nil,tp)
end
function cm.filter1(c,att)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(att) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(cm.ctfilter,nil,tp)
	local tc=g:GetFirst()
	local att=0
	local sg1=0
	local sg2=0
	local sg3=0
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_SPECIAL) then
			att=tc:GetAttribute()
			sg1=sg1+Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil,att):GetCount()
		end
		if tc:IsSummonType(SUMMON_TYPE_ORDER_L) then
			sg2=sg2+Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):GetCount()
		end
		if tc:IsSummonType(SUMMON_TYPE_ORDER_R) then
			sg3=sg3+Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):GetCount()
		end
		tc=g:GetNext()
	end
	if chk==0 then return sg1+sg2+sg3>0 and Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	if sg1>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if sg2>0 then
		local g2=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g2,1,0,0)
	end
	if sg3>0 then
		local g3=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g3,1,0,0)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=eg:Filter(cm.ctfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		local att=tc:GetAttribute()
		local sg1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil,att)
		if tc:IsSummonType(SUMMON_TYPE_SPECIAL) and sg1:GetCount()>0
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local t1=sg1:Select(tp,1,1,nil):GetFirst()
			if t1 then
				Duel.SendtoHand(t1,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,t1)
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_FIELD)
				e0:SetCode(EFFECT_CANNOT_TO_HAND)
				if att==ATTRIBUTE_EARTH then
					e0:SetDescription(aux.Stringid(m,7))
				elseif att==ATTRIBUTE_WATER then
					e0:SetDescription(aux.Stringid(m,8))
				elseif att==ATTRIBUTE_FIRE then
					e0:SetDescription(aux.Stringid(m,9))
				elseif att==ATTRIBUTE_WIND then
					e0:SetDescription(aux.Stringid(m,10))
				elseif att==ATTRIBUTE_LIGHT then
					e0:SetDescription(aux.Stringid(m,11))
				elseif att==ATTRIBUTE_DARK then
					e0:SetDescription(aux.Stringid(m,12))
				elseif att==ATTRIBUTE_DIVINE then
					e0:SetDescription(aux.Stringid(m,13))
				end
				e0:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
				e0:SetTargetRange(1,0)
				e0:SetTarget(cm.thlimit)
				e0:SetLabel(att)
				e0:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e0,tp)
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetTarget(cm.splimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
		local sg2=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if tc:IsSummonType(SUMMON_TYPE_ORDER_L) and sg2:GetCount()>0
			and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local t2=sg2:Select(tp,1,1,nil):GetFirst()
			Duel.NegateRelatedChain(t2,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			t2:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			t2:RegisterEffect(e2)
			if t2:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				t2:RegisterEffect(e3)
			end
		end
		local sg3=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if tc:IsSummonType(SUMMON_TYPE_ORDER_R) and sg3:GetCount()>0
			and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local t3=sg3:Select(tp,1,1,nil)
			Duel.HintSelection(t3)
			Duel.Destroy(t3,REASON_EFFECT)
		end
		tc=g:GetNext()
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0xc13)
end
function cm.filter2(c,rc)
	return c:IsSetCard(0xc13) and not c:IsCode(rc:GetCode()) and c:IsAbleToHand()
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	e:SetLabelObject(rc)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil,rc):GetCount()
	local sg2=0
	local sg3=0
	if re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY then
		sg2=sg2+Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):GetCount()
	end
	if re:GetActiveType()==TYPE_SPELL+TYPE_CONTINUOUS then
		sg3=sg3+Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):GetCount()
	end
	if chk==0 then return sg1+sg2+sg3>0 and rc and Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if sg1>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if sg2>0 then
		local g2=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g2,1,0,0)
	end
	if sg3>0 then
		local g3=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g3,1,0,0)
	end
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil,tc)
	if sg1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local t1=sg1:Select(tp,1,1,nil):GetFirst()
		if t1 then
			Duel.SendtoHand(t1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,t1)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetCode(EFFECT_CANNOT_TO_HAND)
			e0:SetDescription(aux.Stringid(t1:GetCode(),5))
			e0:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
			e0:SetTargetRange(1,0)
			e0:SetTarget(cm.thlimit2)
			e0:SetLabel(t1:GetCode())
			e0:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e0,tp)
		end
	end
	local sg2=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY and sg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local t2=sg2:Select(tp,1,1,nil):GetFirst()
		Duel.NegateRelatedChain(t2,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		t2:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		t2:RegisterEffect(e2)
		if t2:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			t2:RegisterEffect(e3)
		end
	end
	local sg3=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if re:GetActiveType()==TYPE_SPELL+TYPE_CONTINUOUS and sg3:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local t3=sg3:Select(tp,1,1,nil)
		Duel.HintSelection(t3)
		Duel.Destroy(t3,REASON_EFFECT)
	end
end
function cm.thlimit(e,c,tp,re)
	return c:IsAttribute(e:GetLabel()) and re and re:GetHandler():IsCode(99000367)
end
function cm.thlimit2(e,c,tp,re)
	return c:IsCode(e:GetLabel()) and re and re:GetHandler():IsCode(99000367)
end
function cm.splimit(e,c)
	return not c:IsType(TYPE_ORDER) and c:IsLocation(LOCATION_EXTRA)
end