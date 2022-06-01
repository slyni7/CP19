--소울배터리 「다같이 맺은 결의」
function c52646014.initial_effect(c)
	--link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5f6),3,3)
    c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e0:SetValue(1)
    c:RegisterEffect(e0)
	--material
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(52646014,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c52646014.mattg)
    e1:SetOperation(c52646014.matop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(800)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_XMATERIAL)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(c52646014.efilter)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,52646014)
    e4:SetTarget(c52646014.mattg)
    e4:SetOperation(c52646014.matop2)
    c:RegisterEffect(e4)
end
function c52646014.efilterx(c,tc)
   local g=c:GetOverlayGroup()
   return g and g:IsContains(tc)
end
function c52646014.efilter(e,te)
   local c=e:GetOwner()
   local tc=Duel.GetFirstMatchingCard(c52646014.efilterx,0,LOCATION_MZONE,LOCATION_MZONE,nil,c)
   if not tc then
      return false
   end
   local tp=tc:GetControler()
   return tp~=te:GetHandlerPlayer()
end
function c52646014.matfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5f6)
end
function c52646014.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c52646014.matfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c52646014.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c52646014.matop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end
function c52646014.matop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end