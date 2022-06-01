--EE(ÀÌÅÍ³Î ¿¤¸¯¼­) ¸Þ¸£Çî
function c18453247.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c18453247.con1)
	e1:SetOperation(c18453247.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,18453247)
	e2:SetTarget(c18453247.tar2)
	e2:SetOperation(c18453247.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,18453248)
	e3:SetCost(c18453247.cost3)
	e3:SetTarget(c18453247.tar3)
	e3:SetOperation(c18453247.op3)
	c:RegisterEffect(e3)
	e2:SetDescription(aux.Stringid(18453247,0))
	e3:SetDescription(aux.Stringid(18453247,1))
end
function c18453247.nfil1(c)
	return c:IsSetCard(0x2ea) and ((c:IsLocation(LOCATION_HAND) and c:IsDiscardable()) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost())) and c:IsType(TYPE_MONSTER)
end
function c18453247.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18453247.nfil1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c)
end
function c18453247.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c18453247.nfil1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,c)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	else
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c18453247.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanSpecialSummonMonster(tp,18453234,0x2ea,0x4131,1000,1000,2,RACE_FAIRY,ATTRIBUTE_LIGHT)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c18453247.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,18453234,0x2ea,0x4131,1000,1000,2,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		Duel.Exile(c,REASON_EFFECT+REASON_TEMPORARY)
		local token=Duel.CreateToken(tp,18453234)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetLabelObject(token)
		e1:SetOperation(c18453247.op21)
		Duel.RegisterEffect(e1,tp)
	end
end
function c18453247.op21(e,tp,eg,ep,ev,re,r,rp)
	local token=e:GetLabelObject()
	local c=e:GetHandler()
	if eg:IsContains(token) then
		Duel.ReturnToField(c)
		e:Reset()
	end
end
function c18453247.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,18453234)
	end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,18453234)
	Duel.Release(g,REASON_COST)
end
function c18453247.tfil3(c,e,tp)
	return c:IsSetCard(0x2ea) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsCode(18453247) and c:IsType(TYPE_MONSTER)
end
function c18453247.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18453247.tfil3,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c18453247.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18453247.tfil3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end