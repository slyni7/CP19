--천계의 백뱀장어
function c81130100.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81130100,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81130100)
	e1:SetCondition(c81130100.cn)
	c:RegisterEffect(e1)
	--from deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81130100,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,81130101)
	e2:SetCost(c81130100.eco)
	e2:SetTarget(c81130100.etg)
	e2:SetOperation(c81130100.eop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

--summon from hand
function c81130100.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb0)
	and not c:IsCode(81130100)
end
function c81130100.cn(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c81130100.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

--summon from deck
function c81130100.eco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(81130100,tp,ACTIVITY_SPSUMMON)==0
		or Duel.GetCustomActivityCount(81130100,tp,ACTIVITY_SUMMON)==0
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(c81130100.lim)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c81130100.lim(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xcb0)
end
function c81130100.filter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0xcb0)
end
function c81130100.sfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:IsType(TYPE_EFFECT) and c:IsSetCard(0xcb0)
end
function c81130100.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81130100.filter,tp,LOCATION_GRAVE,0,2,nil)
		and Duel.IsExistingMatchingCard(c81130100.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,tp,2,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,tp,1,LOCATION_DECK)
end
function c81130100.eop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81130100.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()>1 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c81130100.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if sg:GetCount()>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
			local dg=sg:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			dg:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			dg:RegisterEffect(e2)
		end
	end
end
