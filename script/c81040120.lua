--꼬마우지

function c81040120.initial_effect(c)

	--treat "Reiuji"
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetValue(81040000)
	c:RegisterEffect(e2)
	
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,81040120)
	e3:SetCondition(c81040120.spcn)
	c:RegisterEffect(e3)
	
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,81040121)
	e4:SetCondition(c81040120.thcn)
	e4:SetTarget(c81040120.thtg)
	e4:SetOperation(c81040120.thop)
	c:RegisterEffect(e4)
	
end

--special summon
function c81040120.spcnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca4) and not c:IsCode(81040120)
end
function c81040120.spcn(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and	   Duel.IsExistingMatchingCard(c81040120.spcnfilter,tp,LOCATION_MZONE,0,1,nil)
end

--search
function c81040120.thcn(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0xca4)
end

function c81040120.thtgfilter(c)
	return c:IsSetCard(0x1ca4) and ( c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP) )
	and c:IsAbleToHand()
end
function c81040120.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81040120.thtgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81040120.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81040120.thtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
