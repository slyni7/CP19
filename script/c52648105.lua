--괴뢰사단의 공연
local m=52648105
local cm=_G["c"..m]
function cm.initial_effect(c)
	--발동
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
	--특수 소환
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_FZONE)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.hspcon)
    e1:SetTarget(cm.hsptg)
    e1:SetOperation(cm.hspop)
    c:RegisterEffect(e1)
	--토큰 소환
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,m)
    e2:SetCondition(cm.spcon)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
	--토큰 이외 공격불가
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetValue(cm.atlimit)
    c:RegisterEffect(e3)
	--토큰 이외 대상불가
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(cm.tglimit)
    e4:SetValue(aux.tgoval)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e5:SetRange(LOCATION_FZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(cm.eftg)
    e5:SetLabelObject(e3)
    c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e6:SetRange(LOCATION_FZONE)
    e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetTarget(cm.eftg)
    e6:SetLabelObject(e4)
    c:RegisterEffect(e6)
end
function cm.cfilter(c)
    return c:IsFacedown() or not c:IsType(TYPE_TOKEN)
end
function cm.hspcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.spfilter(c,e,tp)
    return c:IsSetCard(0x5fe) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

function cm.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5fe)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,52648109,0x5fe,0x4011,500,500,1,RACE_ZOMBIE,ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
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
    end
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

function cm.atlimit(e,c)
    return not c:IsCode(52648109)
end
function cm.tglimit(e,c)
    return not c:IsCode(52648109)
end
function cm.eftg(e,c)
    return c:IsCode(52648109)
end