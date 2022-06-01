--HMS(로열 네이비) 후드
function c81200070.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c81200070.mat,nil,nil,aux.NonTuner(Card.IsSetCard,0xcb7),1,99)
	
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81200070,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,81200070)
	e1:SetCondition(c81200070.cn1)
	e1:SetTarget(c81200070.tg1)
	e1:SetOperation(c81200070.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81200070.cn2)
	c:RegisterEffect(e2)
	
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81200070,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c81200070.co3)
	e3:SetTarget(c81200070.tg3)
	e3:SetOperation(c81200070.op3)
	c:RegisterEffect(e3)

end

--material
function c81200070.mat(c)
	return c:IsType(TYPE_TUNER) or c:IsCode(81200020)
end



--spsummon
function c81200070.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c81200070.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c81200070.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81200070.cfilter,1,nil,1-tp)
end

function c81200070.filter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xcb7)
end
function c81200070.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81200070.filter1(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c81200070.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81200070.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81200070.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_EXTRA)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end

--destroy
function c81200070.filter2(c)
	return c:IsReleasable() and c:IsSetCard(0xcb7)
end
function c81200070.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81200070.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81200070.filter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c81200070.filter3(c)
	return c:IsDestructable() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c81200070.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81200070.filter3,tp,0,LOCATION_MZONE,1,nil)
	end
	local sg=Duel.GetMatchingGroup(c81200070.filter3,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,sg:GetCount()*500)
end
function c81200070.op3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c81200070.filter3,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	if ct then
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end


