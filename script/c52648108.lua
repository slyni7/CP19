--시체의 활용
local m=52648108
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetTarget(cm.target)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetTargetRange(0,1)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(cm.actcon)
    e2:SetValue(1)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(cm.sptg)
    e3:SetOperation(cm.spop)
    c:RegisterEffect(e3)
end
function cm.spfilter(c,e,tp)
    return c:IsSetCard(0x5fe) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
    if chk==0 then return true end
    if Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        e:SetCategory(CATEGORY_SPECIAL_SUMMON)
        e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        e:SetOperation(cm.activate)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    else
        e:SetCategory(0)
        e:SetProperty(0)
        e:SetOperation(nil)
    end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)
        and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        c:SetCardTarget(tc)
    end
    Duel.SpecialSummonComplete()
end

function cm.effilter(c)
    return c:IsLevelAbove(5) and c:IsType(TYPE_TOKEN)
end
function cm.actcon(e)
    local ph=Duel.GetCurrentPhase()
    return Duel.IsExistingMatchingCard(cm.effilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
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