--애상곡
--카드군 번호: 0xca6
function c81050150.initial_effect(c)

	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81050150)
	e1:SetTarget(c81050150.tgtg)
	e1:SetOperation(c81050150.tgop)
	c:RegisterEffect(e1)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,81050150)
	e2:SetCondition(c81050150.cn2)
	e2:SetCost(c81050150.co2)
	e2:SetTarget(c81050150.tg2)
	e2:SetOperation(c81050150.op2)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e2)
end

--send to grave
function c81050150.tgtgfilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xca6)
end
function c81050150.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81050150.tgtgfilter,tp,LOCATION_DECK,0,2,nil)
			end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end

function c81050150.cfilter(c)
	return c:IsAbleToGrave() and c:IsRace(RACE_INSECT)
end
function c81050150.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81050150.tgtgfilter,tp,LOCATION_DECK,0,2,2,nil)
	local cg=Duel.GetMatchingGroup(c81050150.cfilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and cg:GetCount()>0
	and Duel.SelectYesNo(tp,aux.Stringid(81050150,0)) then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=cg:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

--서치
function c81050150.cn2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ( ph==PHASE_MAIN1 or ph==PHASE_MAIN2 )
end
function c81050150.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0x02,0,1,nil)
	end
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_COST)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c81050150.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xca6)
end
function c81050150.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81050150.tfil0,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function c81050150.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81050150.tfil0,tp,0x01,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
