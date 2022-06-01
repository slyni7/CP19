--테라 테르미나
local m=47450010
local cm=_G["c"..m]

function cm.initial_effect(c)
	c:SetSPSummonOnce(m)

	--module summon
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),nil,2,10,nil)

	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	
	
end

function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_MODULE)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_FZONE,LOCATION_FZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_FZONE,LOCATION_FZONE,nil)
	if g:GetCount()>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)

		if ct==0 then
			local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			if #g>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end

		if ct==2 then
			if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,73628505) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,73628505)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,tp,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
			if Duel.IsExistingMatchingCard(Card.IsCode,1-tp,LOCATION_DECK,0,1,nil,73628505) then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(1-tp,Card.IsCode,1-tp,LOCATION_DECK,0,1,1,nil,73628505)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,1-tp,REASON_EFFECT)
					Duel.ConfirmCards(tp,g)
				end
			end
		end
	else
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp, LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end