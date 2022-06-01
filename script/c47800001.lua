--수정 사적 예언자
function c47800001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,47800001)
	e1:SetCondition(c47800001.spcon)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47800001,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,47800002)
	e2:SetCondition(c47800001.thcon)
	e2:SetTarget(c47800001.thtg)
	e2:SetOperation(c47800001.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(47800001,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCondition(c47800001.condition)
	e3:SetTarget(c47800001.target)
	e3:SetOperation(c47800001.activate)
	c:RegisterEffect(e3)
end


function c47800001.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x49e)
end
function c47800001.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c47800001.filter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end

function c47800001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end

function c47800001.thfilter(c)
	return c:IsSetCard(0x49e) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c47800001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47800001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47800001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47800001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c47800001.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0)<=120
end
function c47800001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function c47800001.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK,nil)
	if g:GetCount()<1 then return end
	local dg=g:RandomSelect(tp,1)
	local t=dg:GetFirst()
	while t do
	local cre=t:GetCode()
	local token=Duel.CreateToken(tp,cre)
	Duel.SendtoHand(token,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
	t=dg:GetNext()
	end
	Duel.ShuffleDeck(1-tp)
end