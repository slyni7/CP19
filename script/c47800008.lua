--천재 사적 안두인
function c47800008.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47800008,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,47800008)
	e1:SetTarget(c47800008.thtg)
	e1:SetOperation(c47800008.thop)
	c:RegisterEffect(e1)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetDescription(aux.Stringid(47800008,1))
	e5:SetCountLimit(1,47800009)
	e5:SetCondition(c47800008.con)
	e5:SetOperation(c47800008.op)
	c:RegisterEffect(e5)
end

function c47800008.thfilter(c)
	return c:IsSetCard(0x49e) and c:IsAbleToHand()
end
function c47800008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47800008.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47800008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,nil,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47800008.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c47800008.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rc~=c and rc:IsSetCard(0x49e) and rp==tp and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0)<=40 and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>2
end
function c47800008.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_EXTRA,0)
	if g:GetCount()<3 then return end   

	Duel.Hint(HINT_OPSELECTED,nil,e:GetDescription())

	local dg=g:RandomSelect(tp,3)
	local t=dg:GetFirst()
	while t do
	local cre=t:GetCode()
	local token=Duel.CreateToken(tp,cre)
	Duel.SendtoDeck(token,tp,1,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
	t=dg:GetNext()
	end
end