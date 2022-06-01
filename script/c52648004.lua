--기어스트리트 큐리오스 마니바스
local m=52648004
local cm=_G["c"..m]
function c52648004.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.tucon)
	e2:SetCost(cm.tucost)
	e2:SetOperation(cm.tuop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(cm.addct)
	e3:SetOperation(cm.addc)
	c:RegisterEffect(e3)
end
function cm.splimit(e,c,tp,sumtp,sumpos)
	return not (c:IsAttribute(ATTRIBUTE_WATER) or c:IsRace(RACE_MACHINE))
end
function cm.tgfilter(c,ftype)
	return c:IsType(ftype) and c:IsSetCard(0x5f8) and c:IsAbleToGrave()
end
function cm.ctfilter(c,tp)
	return Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil,c:GetType()) and c:IsFaceup()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and cm.ctfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
							and Duel.IsExistingTarget(cm.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp) 
								and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET) 
	local g=Duel.SelectTarget(tp,cm.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
		
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ftype=tc:GetType()&0x7
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,ftype)
	if g:GetCount()>0 and c:IsRelateToEffect(e) and Duel.SendtoGrave(g,REASON_EFFECT) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1019)
end
function cm.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1019,1)
	end
end
function cm.tucon(e,c)
	return not e:GetHandler():IsType(TYPE_TUNER)
end

function cm.tucost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1019,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1019,1,REASON_COST)
end
function cm.tuop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		c:RegisterEffect(e1)
	end
end
