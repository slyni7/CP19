--yogo

function c81080040.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81080040.spcn)
	e1:SetOperation(c81080040.spop)
	c:RegisterEffect(e1)
	
	--special summon(hand / deck)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81080040,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,81080040)
	e2:SetCost(c81080040.spco2)
	e2:SetTarget(c81080040.sptg2)
	e2:SetOperation(c81080040.spop2)
	c:RegisterEffect(e2)
	
	--noroi
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c81080040.dstg)
	e3:SetOperation(c81080040.dsop)
	c:RegisterEffect(e3)
	
end

--special summon
function c81080040.spcn(e,c)
	if c==nil then 
		return true
	end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
	and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,0)>0
	and Duel.GetCustomActivityCount(81080040,tp,ACTIVITY_SUMMON)==0
	and Duel.GetCustomActivityCount(81080040,tp,ACTIVITY_SPSUMMON)==0
end
function c81080040.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81080040.lim)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c81080040.lim(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xcab)
end

--shd
function c81080040.spcofilter(c)
	return c:IsSetCard(0xcab) and c:IsDiscardable()
end
function c81080040.spco2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
		and Duel.IsExistingMatchingCard(c81080040.spcofilter,tp,LOCATION_HAND,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c81080040.spcofilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c81080040.sptgfilter(c,e,tp)
	return c:IsLevelAbove(7) and c:IsSetCard(0xcab) and c:IsType(TYPE_MONSTER)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81080040.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81080040.sptgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c81080040.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81080040.sptgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--noroi
function c81080040.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return true
	end
	local ec=e:GetHandler():GetEquipTarget()
	ec:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,ec,1,0,0)
end
function c81080040.dsop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if ec and ec:IsRelateToEffect(e) then
		Duel.Release(ec,nil,REASON_EFFECT)
	end
end
