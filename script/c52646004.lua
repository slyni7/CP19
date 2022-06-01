--소울차져 「환희」
function c52646004.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPSUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_BE_MATERIAL)
    e1:SetCountLimit(1,52646004)
    e1:SetCondition(c52646004.spcon)
    e1:SetTarget(c52646004.sptg)
    e1:SetOperation(c52646004.spop)
    c:RegisterEffect(e1)
	-- Atk -2000/dmg reflect
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetCondition(c52646004.ovlinkcon01)
    e2:SetValue(-2000)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(52646004,0))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c52646004.ovlinkcon02)
    e3:SetOperation(c52646004.damop)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(52646004,1))
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
    e4:SetCode(EFFECT_CANNOT_ACTIVATE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,1)
    e4:SetValue(c52646004.aclimit)
    e4:SetCondition(c52646004.actcon)
    c:RegisterEffect(e4)
	--immune targeted
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(52646004,2))
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
    e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c52646004.ovlinkcon2)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetValue(c52646004.efilter)
    c:RegisterEffect(e5)
	--gain soul
	local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c52646004.soulcon)
	e6:SetValue(300)
    c:RegisterEffect(e6)
	local e7=e6:Clone()
    e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
    e8:SetCode(EFFECT_CHANGE_RACE)
    e8:SetValue(RACE_CYBERSE)
	c:RegisterEffect(e8)
	local e9=e6:Clone()
    e9:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e9:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e9)
end
function c52646004.efilter(e,te)
    local c=e:GetHandler()
    local ec=te:GetHandler()
    if ec:IsHasCardTarget(c) then return true end
    return te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)
end
function c52646004.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c52646004.actcon(e)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(c52646002.linkfilter,nil)
    return Duel.GetAttacker()==e:GetHandler() and g:GetSum(Card.GetLink,nil)>=1
end
function c52646004.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(1-ep,ev,false)
end
function c52646004.soulcon(e)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x5f7)
end
function c52646004.linkfilter(c)
    return c:IsType(TYPE_LINK)
end
function c52646004.ovlinkcon01(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646004.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)==0 
end
function c52646004.ovlinkcon02(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646004.linkfilter,nil)
    if g:GetSum(Card.GetLink,nil)==0 then
    return ep==tp and c:IsRelateToBattle() and eg:GetFirst()==c:GetBattleTarget() end
end
function c52646004.ovlinkcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646004.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)>=1
end
function c52646004.ovlinkcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646004.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)>=2
end
function c52646004.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x5f7)
end
function c52646004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c52646004.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
