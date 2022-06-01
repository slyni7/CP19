--USS(이글 유니온) 호넷
function c81170130.initial_effect(c)

	c:SetUniqueOnField(1,0,81170130)
	
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81170130,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,81170130)
	e1:SetCondition(c81170130.cn1)
	e1:SetCost(c81170130.co1)
	e1:SetTarget(c81170130.tg1)
	e1:SetOperation(c81170130.op1)
	c:RegisterEffect(e1)
	
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81170130,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,81170130)
	e2:SetTarget(c81170130.tg2)
	e2:SetOperation(c81170130.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

--spsummon
function c81170130.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcb4)
end
function c81170130.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81170130.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81170130.cofilter(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function c81170130.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81170130.cofilter,tp,LOCATION_HAND,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81170130.cofilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c81170130.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c81170130.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dc=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if dc:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81170130,1)) then
			Duel.BreakEffect()
			local sc=dc:Select(tp,1,1,nil)
			if sc then
				Duel.HintSelection(sc)
				Duel.Destroy(sc,REASON_EFFECT)
			end
		end
	end
end

--salvage
function c81170130.filter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb4) and c:IsType(TYPE_MONSTER)
	and ( c:IsLocation(LOCATION_GRAVE) or ( c:IsFaceup() and c:IsLocation(LOCATION_REMOVED) ) )
	and not c:IsCode(81170130)
end
function c81170130.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81170130.filter1,tp,0x30,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x30)
end
function c81170130.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81170130.filter1,tp,0x30,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


