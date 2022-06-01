--[ hololive Myth ]
local m=99970696
local cm=_G["c"..m]
function cm.initial_effect(c)

	--register effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	
end

--register effect
function cm.filter(c)
	return c:IsFaceup() and c:IsCode(99970691)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	aux.RegisterClientHint(c,nil,tp,1,1,aux.Stringid(m,0),nil)
	for tc in aux.Next(Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)) do
		
		local e0=MakeEff(c,"S","M")
		e0:SetD(m,1)
		e0:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)
		e0:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e0:SetValue(ATTRIBUTE_DARK)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
		
		local e1=MakeEff(c,"S","M")
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetD(m,2)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(cm.efilter)
		tc:RegisterEffect(e1)
		
		local e2=MakeEff(c,"S","M")
		e2:SetD(m,3)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(cm.atkval)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e3)
	
		local e9=MakeEff(c,"S")
		e9:SetD(m,4)
		e9:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e9:SetCode(EFFECT_PIERCE)
		e9:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e9)
		
		local e4=MakeEff(c,"S")
		e4:SetD(m,0)
		e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)

	end
end
function cm.atkval(e)
	local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	return ct*500
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
