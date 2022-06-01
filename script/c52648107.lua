--영혼 재생
local m=52648107
local cm=_G["c"..m]
function cm.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
    e1:SetTarget(cm.thtg)
    e1:SetOperation(cm.thac)
    c:RegisterEffect(e1)
	--토큰
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))    
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
end
function cm.filter(c)
    return c:IsSetCard(0x5fe) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thac(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
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