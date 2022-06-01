--바꿔치기
local m=52648106
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
end
function cm.filter(c)
    return c:IsFaceup() and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,52648109,0x5fe,0x4011,500,500,1,RACE_ZOMBIE,ATTRIBUTE_DARK) 
			and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetLabelObject(tc)
        e1:SetCountLimit(1)
        e1:SetOperation(cm.retop)
        Duel.RegisterEffect(e1,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,52648109,0x5fe,0x4011,500,500,1,RACE_ZOMBIE,ATTRIBUTE_DARK) then
			local token=Duel.CreateToken(tp,52648109)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_DELAY)
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetTargetRange(LOCATION_MZONE,0)
			e2:SetCondition(cm.tkcon)
			e2:SetOperation(cm.tkop)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetLabelObject(lc)
			e3:SetCondition(cm.descon)
			e3:SetOperation(cm.desop)
			token:RegisterEffect(e3)
		end
    end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ReturnToField(e:GetLabelObject())
end
function cm.tkfilter(c)
    return c:IsFaceup() and c:IsCode(52648109)
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
   return eg:IsExists(cm.tkfilter,1,nil,tp)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=eg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsControler(tp) then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetValue(500)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_UPDATE_LEVEL)
			e3:SetValue(1)
			tc:RegisterEffect(e3)
		end
		tc=eg:GetNext()
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    local lc=e:GetLabelObject()
    if lc:GetFlagEffect(m)~=0 then
        return true
    else
        e:Reset()
        return false
    end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local lc=e:GetLabelObject()
    Duel.Destroy(tc,REASON_EFFECT)
end
