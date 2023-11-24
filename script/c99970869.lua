--[ D:011 ]
local s,id=GetID()
function s.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(s.reptg)
	e1:SetValue(s.repval)
	e1:SetOperation(s.repop)
	e1:SetCL(1,{id,1})
	c:RegisterEffect(e1)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_MSET)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(s.sptg(POS_FACEDOWN_DEFENSE))
	e3:SetOperation(s.spop(POS_FACEDOWN_DEFENSE))
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SSET)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(s.con5)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EVENT_CHANGE_POS)
	e6:SetCondition(s.con6)
	c:RegisterEffect(e6)
	
end

function s.thfilter(c)
	return c:IsM() and c:IsSetCard(0xcd6e) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function s.rmfil(c)
	return c:IsSetCard(0xcd6e) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xcd6e)
		and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.dfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(s.rmfil,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfil,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end

function s.filter1(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown()
end
function s.con6(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter1,1,nil)
end
function s.filter2(c,tp)
	return c:IsFacedown()
end
function s.con5(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter2,1,nil,tp)
end

function s.spfilter(c,e,tp,pos)
	return c:IsSetCard(0xcd6e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,pos) and not c:IsCode(id)
end
function s.sptg(pos)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,pos) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	end
end
function s.spop(pos)
	return function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,pos)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,pos)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
