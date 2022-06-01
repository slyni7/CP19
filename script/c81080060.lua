--81080060

function c81080060.initial_effect(c)

	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c81080060.drtg)
	e1:SetOperation(c81080060.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Ss
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,81080060)
	e3:SetCondition(c81080060.spcn)
	e3:SetTarget(c81080060.sptg)
	e3:SetOperation(c81080060.spop)
	c:RegisterEffect(e3)
	
end

--draw
function c81080060.drtgfilter(c)
	return c:IsSetCard(0xcab) and c:IsDiscardable(REASON_EFFECT)
end
function c81080060.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
		and	Duel.IsExistingMatchingCard(c81080060.drtgfilter,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81080060.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c81080060.drtgfilter,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

--Ss
function c81080060.spcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c81080060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81080060.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		then Duel.SendtoGrave(c,REASON_RULE)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x47e0000)
	e1:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e1)
end
