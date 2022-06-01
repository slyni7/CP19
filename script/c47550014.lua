--지하도시 네파시아
function c47550014.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,47550014+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)

	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c47550014.thtg)
	e1:SetOperation(c47550014.thop)
	c:RegisterEffect(e1)

	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c47550014.thcon)
	e2:SetTarget(c47550014.thtg2)
	e2:SetOperation(c47550014.thop2)
	c:RegisterEffect(e2)

	--healban
	local rec=Duel.Recover
	Duel.Recover=function(tp,val,r)
		if Duel.IsPlayerAffectedByEffect(tp,47550014) then
			return 0
		else
			return rec(tp,val,r)
		end
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(47550014)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)

end

function c47550014.thfilter(c)
	return c:IsSetCard(0x487) and c:IsAbleToHand() and not c:IsCode(47550014)
end
function c47550014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47550014.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47550014.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47550014.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c47550014.thfilter2(c)
	return c:IsSetCard(0x487) and c:IsAbleToHand() and not c:IsCode(47550014)
end
function c47550014.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and Duel.GetTurnPlayer()~=tp
end
function c47550014.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c47550014.thop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c47550014.thfilter2,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end