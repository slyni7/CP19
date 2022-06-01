--タイコーリング

function c81070030.initial_effect(c)
	
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81070030+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81070030.spcn)
	e1:SetCost(c81070030.spco)
	e1:SetTarget(c81070030.sptg)
	e1:SetOperation(c81070030.spop)
	c:RegisterEffect(e1)
	
end

--activate
function c81070030.spcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c81070030.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetCustomActivityCount(81070030,tp,ACTIVITY_SUMMON)==0
		and	Duel.GetCustomActivityCount(81070030,tp,ACTIVITY_SPSUMMON)==0 
	end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81070030.splm)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c81070030.splm(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xcaa)
end
function c81070030.filter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcaa) and c:IsType(TYPE_MONSTER)
end
function c81070030.filter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP)
end
function c81070030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81070030.filter0,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c81070030.filter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c81070030.spop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c81070030.filter0,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c81070030.filter1,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
end


