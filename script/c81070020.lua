--야츠하시

function c81070020.initial_effect(c)

	--damage, atk decrease
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81070020,1))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81070020.cn1)
	e1:SetCost(c81070020.daco)
	e1:SetTarget(c81070020.datg)
	e1:SetOperation(c81070020.daop)
	c:RegisterEffect(e1)
	
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81070020,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81070021)
	e2:SetCost(c81070020.spco)
	e2:SetTarget(c81070020.sptg)
	e2:SetOperation(c81070020.spop)
	c:RegisterEffect(e2)
	
end

--damage, atk decrease
function c81070020.filter0(c)
	return c:IsFaceup() and c:IsSetCard(0xcaa)
end
function c81070020.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c81070020.filter0,tp,LOCATION_MZONE,0,nil)>0
end
function c81070020.daco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				c:IsDiscardable()
			end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c81070020.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
			end
end
function c81070020.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-400)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.Damage(1-tp,400,REASON_EFFECT)
end

--special summon
function c81070020.spcofilter(c)
	return ( c:IsLocation(LOCATION_HAND) or c:IsFaceup() )
	   and c:IsAbleToGraveAsCost()
	   and ( c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
end
function c81070020.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_SZONE
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81070020.spcofilter,tp,loc,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81070020.spcofilter,tp,loc,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c81070020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c81070020.spop(e,tp,eg,ep,ev,re,r,rp)
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
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(400)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
		end
	end
end
