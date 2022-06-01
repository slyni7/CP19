--[ hololive 3rd Gen ]
local m=99970658
local cm=_G["c"..m]
function cm.initial_effect(c)

	--패 발동
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	
	--무효화
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)

end

--패 발동
function cm.cfil(c)
	return c:IsFaceup() and c:IsSetCard(0xd63)
end
function cm.handcon(e)
	local g=Duel.GetMatchingGroup(cm.cfil,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end

--무효화
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(99970652)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc and aux.disfilter1(tc) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	local gx=Duel.GetMatchingGroup(cm.cfil,tp,LOCATION_MZONE,0,nil)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if gx:GetClassCount(Card.GetCode)>=5 and #g1>0 then
		Duel.BreakEffect()
		local ng=g1:Filter(aux.disfilter1,nil)
		for nc in aux.Next(ng) do
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			nc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_DISABLE_EFFECT)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			nc:RegisterEffect(e5)
		end
	end
end
function cm.gura(c)
	return c:IsFaceup() and c:IsCode(99970695)
end
