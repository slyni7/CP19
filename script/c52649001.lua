--CB(커먼 버그) - 닐 콜링
local m=52649001
local cm=_G["c"..m]
function c52649001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
    e1:SetTarget(cm.eqtg)
    e1:SetOperation(cm.eqop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1,152649001)
    e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.pcon)
    e3:SetTarget(cm.target)
    e3:SetOperation(cm.operation)
    c:RegisterEffect(e3)
	local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e8:SetCode(EVENT_SUMMON_SUCCESS)
    e8:SetOperation(cm.errop)
    c:RegisterEffect(e8)
	local e9=e8:Clone()
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e9)
end
function cm.errop(e,tp,eg,ep,ev,re,r,rp)
    Debug.Message("attempt to index a nil value")
end
function cm.pcon(e)
    return e:GetHandler():GetEquipCount()>0
end
function cm.filter(c)
    return c:IsRace(RACE_INSECT) and c:IsLevelBelow(4) and not c:IsForbidden()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,c)
    local tc=g:GetFirst()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        if not Duel.Equip(tp,tc,c,true) then return end
        --Add Equip limit
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(cm.eqlimit)
        tc:RegisterEffect(e1)
    else Duel.SendtoGrave(tc,REASON_RULE) end
end
function cm.eqlimit(e,c)
    return e:GetOwner()==c
end
function cm.rfilter(c,e,tp,m,ft)
    if not c:IsSetCard(0x5f9) or bit.band(c:GetType(),0x81)~=0x81
        or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    if c.mat_filter then
        mg=mg:Filter(c.mat_filter,nil)
    end
    if ft>0 then
        return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
    else
        return ft>-1 and mg:IsExists(cm.mfilterf,1,nil,tp,mg,c)
    end
end
function cm.mfilterf(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
    else return false end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp)
        mg:RemoveCard(e:GetHandler())
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():GetSequence()<5 then ft=ft+1 end
        return Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetRitualMaterial(tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
    local tc=tg:GetFirst()
    if tc then
        mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
            if tc.mat_filter then
                mg=mg:Filter(tc.mat_filter,nil)
            end
            local mat=nil
            if ft>0 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
            else
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,tc)
                Duel.SetSelectedCard(mat)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
                mat:Merge(mat2)
            end
            tc:SetMaterial(mat)
            Duel.ReleaseRitualMaterial(mat)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end