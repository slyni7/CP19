--티아라 이클립스
function c17280010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17280010,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1)
	e2:SetCost(c17280010.cost2)
	e2:SetTarget(c17280010.tg2)
	e2:SetOperation(c17280010.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17280010,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCountLimit(1,17280010)
	e3:SetCost(c17280010.cost3)
	e3:SetTarget(c17280010.tg3)
	e3:SetOperation(c17280010.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,17280011)
	e4:SetCondition(c17280010.con4)
	e4:SetCost(c17280010.cost4)
	e4:SetTarget(c17280010.tg4)
	e4:SetOperation(c17280010.op4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c17280010.cfilter21(c,e,tp)
	local att=c:GetAttribute()
	local satt=0
	if bit.band(att,ATTRIBUTE_FIRE)==ATTRIBUTE_FIRE then
		satt=satt+ATTRIBUTE_WATER
	end
	if bit.band(att,ATTRIBUTE_LIGHT)==ATTRIBUTE_LIGHT then
		satt=satt+ATTRIBUTE_DARK
	end
	if bit.band(att,ATTRIBUTE_WIND)==ATTRIBUTE_WIND then
		satt=satt+ATTRIBUTE_EARTH
	end
	if bit.band(att,ATTRIBUTE_WATER)==ATTRIBUTE_WATER then
		satt=satt+ATTRIBUTE_FIRE
	end
	if bit.band(att,ATTRIBUTE_EARTH)==ATTRIBUTE_EARTH then
		satt=satt+ATTRIBUTE_WIND
	end
	if bit.band(att,ATTRIBUTE_DARK)==ATTRIBUTE_DARK then
		satt=satt+ATTRIBUTE_LIGHT
	end
	if satt==0 then
		return false
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return c:GetSequence()<5
	end
	return Duel.IsExistingMatchingCard(c17280010.cfilter22,tp,LOCATION_DECK,0,1,nil,e,tp,satt)
end
function c17280010.cfilter22(c,e,tp,att)
	return c:IsSetCard(0x2c4) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17280010.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
			return Duel.CheckReleaseGroup(tp,c17280010.cfilter21,1,nil,e,tp)
		else
			return Duel.CheckReleaseGroupEx(tp,c17280010.cfilter21,1,nil,e,tp)
		end
	end
	c:RegisterFlagEffect(17280010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	local g=nil
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		g=Duel.SelectReleaseGroup(tp,c17280010.cfilter21,1,1,nil,e,tp)
	else
		g=Duel.SelectReleaseGroupEx(tp,c17280010.cfilter21,1,1,nil,e,tp)
	end
	local tc=g:GetFirst()
	local att=tc:GetAttribute()
	local satt=0
	if bit.band(att,ATTRIBUTE_FIRE)==ATTRIBUTE_FIRE then
		satt=satt+ATTRIBUTE_WATER
	end
	if bit.band(att,ATTRIBUTE_LIGHT)==ATTRIBUTE_LIGHT then
		satt=satt+ATTRIBUTE_DARK
	end
	if bit.band(att,ATTRIBUTE_WIND)==ATTRIBUTE_WIND then
		satt=satt+ATTRIBUTE_EARTH
	end
	if bit.band(att,ATTRIBUTE_WATER)==ATTRIBUTE_WATER then
		satt=satt+ATTRIBUTE_FIRE
	end
	if bit.band(att,ATTRIBUTE_EARTH)==ATTRIBUTE_EARTH then
		satt=satt+ATTRIBUTE_WIND
	end
	if bit.band(att,ATTRIBUTE_DARK)==ATTRIBUTE_DARK then
		satt=satt+ATTRIBUTE_LIGHT
	end
	e:SetLabel(satt)
	Duel.Release(g,REASON_COST)
end
function c17280010.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c17280010.op2(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabel()
	if att==0 then
		return
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c17280010.cfilter22,tp,LOCATION_DECK,0,1,1,nil,e,tp,att)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c17280010.cfilter31(c,tp)
	if not c:IsSetCard(0x2c4) or not c:IsType(TYPE_MONSTER) or not c:IsAbleToGraveAsCost() then
		return false
	end
	local code=c:GetCode()
	if c:IsType(TYPE_TUNER) then
		return Duel.IsExistingMatchingCard(c17280010.cfilter32,tp,LOCATION_DECK,0,1,nil,code)
	else
		return Duel.IsExistingMatchingCard(c17280010.cfilter33,tp,LOCATION_DECK,0,1,nil,code)
	end
end
function c17280010.cfilter32(c,code)
	return c:IsSetCard(0x2c4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsType(TYPE_TUNER) and not c:IsCode(code)
end
function c17280010.cfilter33(c,code)
	return c:IsSetCard(0x2c4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsType(TYPE_TUNER) and not c:IsCode(code)
end
function c17280010.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(17280010)<1 and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c17280010.cfilter31,tp,LOCATION_HAND,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c17280010.cfilter31,tp,LOCATION_HAND,0,1,1,nil,tp)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c17280010.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17280010.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local code=tc:GetCode()
	local g=nil
	if tc:IsType(TYPE_TUNER) then
		g=Duel.GetMatchingGroup(c17280010.cfilter32,tp,LOCATION_DECK,0,nil,code)
	else		
		g=Duel.GetMatchingGroup(c17280010.cfilter33,tp,LOCATION_DECK,0,nil,code)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(17280010,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=g:Select(tp,1,1,nil)
		g1:Merge(g2)
	end
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end
function c17280010.nfilter4(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x2c4)
end
function c17280010.con4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c17280010.nfilter4,1,nil,tp)
end
function c17280010.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c17280010.tfilter4(c)
	return c:IsSetCard(0x2c4) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c17280010.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c17280010.tfilter4,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17280010.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17280010.tfilter4,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end