--소울차져 「의문」
function c52646001.initial_effect(c)
	--no tribute
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(52646001,0))
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetOperation(c52646001.ntop)
    c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPSUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetCountLimit(1,52646001)
    e2:SetCondition(c52646001.spcon)
    e2:SetTarget(c52646001.sptg)
    e2:SetOperation(c52646001.spop)
    c:RegisterEffect(e2)
	--indes battle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(52646001,1))
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c52646001.ovlinkcon0)
    e3:SetValue(1)
    c:RegisterEffect(e3)
	 --search
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(52646001,2))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetCountLimit(1,52646999)
    e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c52646001.ovlinkcon1)
    e4:SetCost(c52646001.thcost)
    e4:SetTarget(c52646001.thtg)
    e4:SetOperation(c52646001.thop)
    c:RegisterEffect(e4)
	--gain soul
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c52646001.soulcon)
	e5:SetValue(300)
    c:RegisterEffect(e5)
	local e6=e5:Clone()
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
    e7:SetCode(EFFECT_CHANGE_RACE)
    e7:SetValue(RACE_CYBERSE)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
    e8:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e8:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e8)
end
function c52646001.soulcon(e)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x5f7)
end
function c52646001.ntop(e,tp,eg,ep,ev,re,r,rp,c)
    --negate
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end
function c52646001.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x5f7)
end
function c52646001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c52646001.spop(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        if c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
            Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
end
function c52646001.linkfilter(c)
    return c:IsType(TYPE_LINK)
end
function c52646001.ovlinkcon0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646001.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)==0
end
function c52646001.ovlinkcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646001.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)>=1
end
function c52646001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c52646001.thfilter(c)
    return c:IsSetCard(0x5f6) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c52646001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52646001.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c52646001.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c52646001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end