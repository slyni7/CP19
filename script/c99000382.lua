--인조천사는 천사를 꿈꾸는가
local m=99000382
local cm=_G["c"..m]
function cm.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(0xff,0)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function cm.Synthetic_Seraphim_filter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_FAIRY)
end
function cm.actfilter(c,tp)
	return c:IsCode(16946849) and c:GetActivateEffect():IsActivatable(tp)
end
function cm.filter(c)
	return c:IsCode(16946849) and c:IsFaceup()
end
function cm.filter1(c,tp)
	return c:IsSetCard(0xc12) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,c)
end
function cm.filter2(c)
	return c:IsType(TYPE_COUNTER) and c:IsAbleToGrave()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil,tp)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		if Duel.IsExistingMatchingCard(cm.Synthetic_Seraphim_filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
			and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_TRAP+TYPE_COUNTER)
			c:RegisterEffect(e1,true)
		end
		if e1 then e1:Reset() end
		return b1 or b2
	end
	e:SetLabel(0)
	if Duel.IsExistingMatchingCard(cm.Synthetic_Seraphim_filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
		and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:SetSpellSpeed(3)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_TRAP+TYPE_COUNTER)
		c:RegisterEffect(e2,true)
		c:CancelToGrave(false)
	end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	e:SetLabel(op)
	if op~=0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
	if e2 then e2:Reset() end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetRange(LOCATION_SZONE)
			e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil,tp)
		if hg:GetCount()>0 and Duel.SendtoHand(hg,tp,REASON_EFFECT)>0
			and hg:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,hg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
function cm.eftg(e,c)
	if c:IsCode(16946849) and c:GetFlagEffect(m)==0 then
		c:RegisterFlagEffect(m,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
	return c:IsCode(16946849)
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and (c:IsSetCard(0xc12) or c:IsCode(16946849) or c:IsCode(16946850)) and not c:IsReason(REASON_REPLACE)
end
function cm.desfilter(c)
	return (c:IsSetCard(0xc12) or c:IsCode(16946849) or c:IsCode(16946850)) and c:IsReleasableByEffect()
		and c:IsControler(tp) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		e:SetLabelObject(g:GetFirst())
		return true
	end
	return false
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local tc=e:GetLabelObject()
	Duel.Release(tc,REASON_EFFECT+REASON_REPLACE)
end