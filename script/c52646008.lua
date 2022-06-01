--템포러리 소울차져
function c52646008.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(52646008,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,52646008)
    e1:SetTarget(c52646008.mattg)
    e1:SetOperation(c52646008.matop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(52646008,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,52646992)
    e2:SetTarget(c52646008.spptg)
    e2:SetOperation(c52646008.sppop)
    c:RegisterEffect(e2)
end
function c52646008.spptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,52646008,0x5f6,0x21,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c52646008.sppop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,52646008,0x5f6,0x21,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) then
        c:AddMonsterAttribute(TYPE_EFFECT,0,0,1,0,0)
        Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
        c:AddMonsterAttributeComplete()
        Duel.SpecialSummonComplete()
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e0:SetValue(1)
		c:RegisterEffect(e0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e1:SetOperation(c52646008.des)
		c:RegisterEffect(e1)
    end
end
function c52646008.xyzfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5f6)
end
function c52646008.matfilter(c)
    return c:IsSetCard(0x5f7)
end
function c52646008.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c52646008.xyzfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c52646008.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(c52646008.matfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c52646008.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c52646008.matop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local g=Duel.SelectMatchingCard(tp,c52646008.matfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.Overlay(tc,g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			e1:SetOperation(c52646008.des)
			tc:RegisterEffect(e1)
        end
    end
end
function c52646008.des(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end