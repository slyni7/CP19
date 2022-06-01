--흑곡-야츠카하기
function c81050200.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c81050200.mat1,2,2)
	
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(81050000)
	c:RegisterEffect(e1)
	
	--t set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c81050200.cn2)
	e2:SetOperation(c81050200.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81050200,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81050200)
	e3:SetCondition(c81050200.cn3)
	e3:SetTarget(c81050200.tg3)
	e3:SetOperation(c81050200.op3)
	c:RegisterEffect(e3)
	
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81050200,1))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c81050200.cn4)
	e4:SetCost(c81050200.co4)
	e4:SetTarget(c81050200.tg4)
	e4:SetOperation(c81050200.op4)
	c:RegisterEffect(e4)
end

--material
function c81050200.mat1(c)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_EARTH)
end

--t set
function c81050200.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c81050200.op2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(81050200,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end

function c81050200.cn3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(81050200)~=0
end
function c81050200.filter1(c)
	return c:IsSSetable() and c:IsSetCard(0x1ca6) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81050200.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c81050200.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	end
end
function c81050200.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c81050200.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end

--summon
function c81050200.cn4(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp
	and ( ph==PHASE_MAIN1 or ( ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE  ) or ph==PHASE_MAIN2 )
end
function c81050200.filter2(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xca6)
end
function c81050200.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81050200.filter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81050200.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81050200.sfilter(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0xca6)
end
function c81050200.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81050200.sfilter,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c81050200.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c81050200.sfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end


