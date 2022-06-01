--죽을 때까지만 빌리겠다구
function c47800020.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47800020,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c47800020.condition)
	e2:SetTarget(c47800020.target)
	e2:SetOperation(c47800020.operation)
	c:RegisterEffect(e2)
end
function c47800020.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x49e) and not c:IsCode(47800020)
end
function c47800020.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0)<=120 and Duel.IsExistingMatchingCard(c47800020.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c47800020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end

function c47800020.cfilter(c)
	return c:IsFaceup() and c:IsCode(47800010)
end

function c47800020.operation(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) then return end

	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK,nil)
	if g:GetCount()==0 then return end

	local gs=Duel.GetDecktopGroup(1-tp,1)
	local t=gs:GetFirst():GetCode()
	local token=Duel.CreateToken(tp,t)
	Duel.SendtoHand(token,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)

	if Duel.IsExistingMatchingCard(c47800020.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(47800020,1)) then
	local dg=g:RandomSelect(tp,1)
	local t=dg:GetFirst():GetCode()
	local token2=Duel.CreateToken(tp,t)
	Duel.SendtoHand(token2,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token2)
	Duel.ShuffleDeck(1-tp)
	end

end