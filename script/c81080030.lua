--81080030

function c81080030.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81080030.spcn)
	e1:SetOperation(c81080030.spop)
	c:RegisterEffect(e1)
	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81080030)
	e2:SetCost(c81080030.scco)
	e2:SetTarget(c81080030.sctg)
	e2:SetOperation(c81080030.scop)
	c:RegisterEffect(e2)
	
	--bounce
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c81080030.cn)
	e3:SetTarget(c81080030.thtg)
	e3:SetOperation(c81080030.thop)
	c:RegisterEffect(e3)
	
end

--special summon
function c81080030.spcn(e,c)
	if c==nil then 
		return true
	end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
	and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,0)>0
	and Duel.GetCustomActivityCount(81080030,tp,ACTIVITY_SUMMON)==0
	and Duel.GetCustomActivityCount(81080030,tp,ACTIVITY_SPSUMMON)==0
end
function c81080030.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81080030.lim)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c81080030.lim(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xcab)
end

--search
function c81080030.sccofilter(c)
	return c:IsSetCard(0xcab) and c:IsDiscardable()
end
function c81080030.scco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81080030.sccofilter,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,c81080030.sccofilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c81080030.sctgfilter(c)
	return c:IsSetCard(0xcab) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsAbleToHand()
end
function c81080030.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81080030.sctgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81080030.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINT_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81080030.sctgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--zikake
function c81080030.cn(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local player=Duel.GetTurnPlayer()
	return (ph==PHASE_MAIN1 and player==tp) or (ph==PHASE_MAIN2 and player==tp)
end

function c81080030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return true
	end
	local ec=e:GetHandler():GetEquipTarget()
	ec:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,ec,1,0,0)
end
function c81080030.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then
		return
	end
	local ec=e:GetHandler():GetEquipTarget()
	if ec and ec:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(Group.FromCards(ec,e:GetHandler()),nil,REASON_EFFECT)
	end
end
