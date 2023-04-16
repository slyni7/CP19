--HMS 일러스트리어스
--카드군 번호: 0xcb7

function c81200170.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c81200170.mat,nil,nil,aux.NonTuner(Card.IsSetCard,0xcb7),1,99)
	
	--Untargetable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81200170,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,81200170)
	e1:SetCondition(c81200170.cn1)
	e1:SetTarget(c81200170.tg1)
	e1:SetOperation(c81200170.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81200170.cn2)
	c:RegisterEffect(e2)
	
	--synchro
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81200170,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81200171)
	e3:SetCondition(c81200170.cn3)
	e3:SetTarget(c81200170.tg3)
	e3:SetOperation(c81200170.op3)
	c:RegisterEffect(e3)
end

--material
function c81200170.mat(c)
	return c:IsType(TYPE_TUNER) or c:IsCode(81200020)
end

--Untargetable
function c81200170.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c81200170.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c81200170.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81200170.cfilter,1,nil,1-tp)
end

function c81200170.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then 
		return true
	end
	if chk==0 then
		return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetChainLimit(c81200170.limit)
end
function c81200170.limit(e,ep,tp)
	return tp==ep
end
function c81200170.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

--synchro
function c81200170.cn3(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ( ph==PHASE_MAIN1 or ph==PHASE_MAIN2 )
end
function c81200170.mfilter0(c,tp)
	return c:IsSetCard(0xcb7) and c:IsAbleToGrave() and Duel.GetLocationCountFromEx(tp,tp,c)>-1
end
function c81200170.spfilter1(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xcb7) and not c:IsCode(81200170)
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,false)
end
function c81200170.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c81200170.mfilter0,tp,LOCATION_MZONE,0,1,c,tp)
		and Duel.IsExistingMatchingCard(c81200170.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c81200170.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c81200170.mfilter0,tp,LOCATION_ONFIELD,0,1,1,c,tp)
	tg:AddCard(c)
	if tg and Duel.SendtoGrave(tg,REASON_EFFECT)==2 then
		if Duel.GetLocationCountFromEx(tp)<=-2 then
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c81200170.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local mg=sg:GetFirst()
		if mg and Duel.SpecialSummon(mg,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)~=0 then
			mg:CompleteProcedure()
		end
	end
end


