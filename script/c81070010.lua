--벤벤

function c81070010.initial_effect(c)

	--search to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81070010,3))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81070010)
	e1:SetCondition(c81070010.shcn)
	e1:SetTarget(c81070010.shtg)
	e1:SetOperation(c81070010.shop)
	c:RegisterEffect(e1)
	if not c81070010.global_check then
		c81070010.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetLabel(81070010)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(81070010)
		Duel.RegisterEffect(ge2,0)
	end
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81070010,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81070011)
	e2:SetCost(c81070010.spco)
	e2:SetTarget(c81070010.sptg)
	e2:SetOperation(c81070010.spop)
	c:RegisterEffect(e2)
	
end

--search to hand
function c81070010.shcnfilter(c)
	return c:IsFaceup()
	   and c:GetAttack()~=c:GetBaseAttack()
end
function c81070010.shcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81070010.shcnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	   and e:GetHandler():GetFlagEffect(81070010)>0
end

function c81070010.shtgfilter(c)
	return c:IsAbleToHand()
	   and c:IsSetCard(0xcaa) and not c:IsCode(81070010)
end
function c81070010.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81070010.shtgfilter,tp,LOCATION_DECK,0,1,nil)
			end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81070010.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81070010.shtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--special summon
function c81070010.spcofilter(c)
	return ( c:IsLocation(LOCATION_HAND) or c:IsFaceup() )
	   and c:IsAbleToGraveAsCost()
	   and ( c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
end
function c81070010.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_SZONE
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81070010.spcofilter,tp,loc,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81070010.spcofilter,tp,loc,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c81070010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c81070010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-600)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENCE)
			tc:RegisterEffect(e2)
		end
	end
end
