--네파시아 침식령
function c47550022.initial_effect(c)

	--link summon
	aux.AddLinkProcedure(c,c47550022.mfilter,1,1)
	c:EnableReviveLimit()

	--spsummonlimit
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e99:SetCode(EVENT_SPSUMMON_SUCCESS)
	e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e99:SetCondition(c47550022.con1)
	e99:SetOperation(c47550022.op1)
	c:RegisterEffect(e99)

	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,47550022)
	e1:SetCondition(c47550022.thcon)
	e1:SetTarget(c47550022.thtg)
	e1:SetOperation(c47550022.thop)
	c:RegisterEffect(e1)

	--revive
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,47550023)
	e2:SetCost(c47550022.spcost)
	e2:SetTarget(c47550022.sptg)
	e2:SetOperation(c47550022.spop)
	c:RegisterEffect(e2)
	
end

function c47550022.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c47550022.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c47550022.tar11)
	Duel.RegisterEffect(e1,tp)
end
function c47550022.tar11(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(47550022) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end



function c47550022.mfilter(c)
	return c:IsLinkSetCard(0x487) and not c:IsCode(47550022)
end
function c47550022.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47550022.thfilter(c)
	return c:IsCode(47550014) and c:IsAbleToHand()
end
function c47550022.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47550022.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47550022.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47550022.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)

		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(47550022,0)) then

			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end



function c47550022.cfilter(c,tp)
	return c:IsLinkSetCard(0x487) and c:IsAttribute(ATTRIBUTE_DARK) and Duel.GetMZoneCount(tp,c)>0 and not c:IsCode(47550022)
end
function c47550022.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c47550022.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c47550022.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c47550022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47550022.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end