--소울배터리 「홀로 깨달은 마음」
function c52646012.initial_effect(c)
	--link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5f6),1,1)
    c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e0:SetValue(1)
    c:RegisterEffect(e0)
	--material
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(52646012,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c52646012.mattg)
    e1:SetOperation(c52646012.matop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(200)
    c:RegisterEffect(e2)
	local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(-200)
	c:RegisterEffect(e3)
end
function c52646012.matfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5f6)
end
function c52646012.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c52646012.matfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c52646012.matfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c52646012.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c52646012.matop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end
