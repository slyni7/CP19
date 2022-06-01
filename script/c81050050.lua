--흑곡의 자채사

function c81050050.initial_effect(c)

	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,81050050)
	e1:SetCost(c81050050.drco)
	e1:SetTarget(c81050050.drtg)
	e1:SetOperation(c81050050.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81050050,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,81050051)
	e3:SetCondition(c81050050.spcn)
	e3:SetTarget(c81050050.sptg)
	e3:SetOperation(c81050050.spop)
	c:RegisterEffect(e3)

end

--draw
function c81050050.drco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end

function c81050050.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c81050050.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc:IsSetCard(0xca6) and Duel.IsPlayerCanDraw(tp,2)
			and Duel.SelectYesNo(tp,aux.Stringid(81050050,0)) then
			Duel.BreakEffect()
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			Duel.Draw(tp,2,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		end
	end
end

--special summon
function c81050050.spcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SUMMON and c:GetReasonCard():IsRace(RACE_INSECT)
end

function c81050050.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return true end
	if chk==0 then return c:IsRelateToEffect(e)
					  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
					  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
					  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c81050050.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
