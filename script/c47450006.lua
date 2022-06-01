--하늘을 읽는 스텔라리스
local m=47450006
local cm=_G["c"..m]

function cm.initial_effect(c)
	c:SetSPSummonOnce(m)

	--module summon
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),nil,1,10,nil)

	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.eqcon)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)

	--bounce
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	
end

function cm.eqfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup())) and Duel.IsExistingMatchingCard(cm.eqfilter2,tp,LOCATION_DECK,0,1,nil,c,e,tp)
end

function cm.eqfilter2(c,tc,e,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c:GetOriginalRace()==tc:GetOriginalRace() and c:GetOriginalAttribute()==tc:GetOriginalAttribute() and c:CheckUniqueOnField(tp)
end

function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_MODULE)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()<1 then return false end
	if chkc then return mg:IsContains(chkc) and cm.eqfilter(chkc,e,tp) end
	if chk==0 then return mg:IsExists(cm.eqfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=mg:FilterSelect(tp,cm.eqfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end

function cm.eqop(e,tp,eg,ep,ev,re,r,rp)

	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()

	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not tc:IsRelateToEffect(e) then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=Duel.SelectMatchingCard(tp,cm.eqfilter2,tp,LOCATION_DECK,0,1,1,nil,tc,e,tp)
	local sc=sg:GetFirst()
	if c:IsRelateToEffect(e) and sc then
		if not Duel.Equip(tp,sc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(cm.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
	end

	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.otar11)
	Duel.RegisterEffect(e2,tp)

end

function cm.otar11(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_MODULE)
end

function cm.eqlimit(e,c)
  return e:GetOwner()==c
end




function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_MODULE and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end

function cm.thfilter(c,e)
	return c:IsFaceup() and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end