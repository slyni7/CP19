--사피론 매드 버터플라이
function c47500006.initial_effect(c)
	
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c47500006.matfilter),3,2)
	c:EnableReviveLimit()

	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,47500006)
	e1:SetCost(c47500006.cost)
	e1:SetTarget(c47500006.settg)
	e1:SetOperation(c47500006.op)
	c:RegisterEffect(e1)

	--tam yok
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,47500106)
	e2:SetOperation(c47500006.activate)
	c:RegisterEffect(e2)

	--tal ju
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,47500206)
	e3:SetCost(c47500006.spcost)
	e3:SetCondition(c47500006.spcon)
	e3:SetTarget(c47500006.sptg)
	e3:SetOperation(c47500006.spop)
	c:RegisterEffect(e3)   
	

end


function c47500006.matfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_WIND)
end

function c47500006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end


function c47500006.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable() and c:IsSetCard(0x475)
end

function c47500006.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c47500006.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
end

function c47500006.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g2=Duel.SelectMatchingCard(tp,c47500006.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc2=g2:GetFirst()

	if tc2 and Duel.SSet(tp,tc2) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc2:RegisterEffect(e1)
	end
end


function c47500006.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c47500006.indtg)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

function c47500006.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end




function c47500006.filters(c,e,tp)
	return c:IsSetCard(0x475) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(47500006) and c:IsType(TYPE_MONSTER)
end

function c47500006.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(c)
end

function c47500006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end


function c47500006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c47500006.filters,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function c47500006.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=2
	if Duel.IsPlayerAffectedByEffect(tp,59822133,14941411) or ft<2 then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47500006.filters),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,ct,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc=g:GetNext()
	end
end