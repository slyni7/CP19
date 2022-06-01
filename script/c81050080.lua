--칸다타 로프

function c81050080.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81050080+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81050080.spco)
	e1:SetTarget(c81050080.sptg)
	e1:SetOperation(c81050080.spop)
	c:RegisterEffect(e1)
	
	--search & to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81050080,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c81050080.thco)
	e2:SetTarget(c81050080.thtg)
	e2:SetOperation(c81050080.thop)
	c:RegisterEffect(e2)
	
end

--special summon
function c81050080.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
		and Duel.CheckLPCost(tp,2000)
	end
	Duel.PayLPCost(tp,2000)
end
function c81050080.sptgfilter(c,e,tp)
	return ( c:IsSetCard(0xca6) and c:IsType(TYPE_MONSTER) )
	   and c:IsLevelBelow(4)
	   and c:IsCanBeSpecialSummoned(e,0,tp,tp,false,false)
end
function c81050080.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return 
				chkc:IsLocation(LOCATION_GRAVE)
			and chkc:IsControler()
			and c81050080.sptgfilter(chkc,e,tp)
			end
	if chk==0 then return 
				Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and	Duel.IsExistingTarget(c81050080.sptgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
			end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81050080.sptgfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end

function c81050080.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
end

--search & to hand
function c81050080.thco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function c81050080.thtgfilter(c)
	return c:IsLevelAbove(5) and ( c:IsSetCard(0xca6) and c:IsType(TYPE_MONSTER) )
	and c:IsAbleToHand()
end
function c81050080.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
				Duel.IsExistingMatchingCard(c81050080.thtgfilter,tp,LOCATION_DECK,0,1,nil)
			end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81050080.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81050080.thtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
