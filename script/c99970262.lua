--Mystic Orchestra
local m=99970262
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Mystic Orchestra
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	
	--바운스
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.condition1)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.activate1)
	c:RegisterEffect(e2)

end

--Mystic Orchestra
function cm.filter(c)
	return ((c:IsSetCard(0xe03) and c:IsType(TYPE_TRAP)) or c:IsSetCard(0xd3f)) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe03,0xa1,1500,1500,3,RACE_SPELLCASTER,ATTRIBUTE_LIGHT)
		or Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xd3f,0xa1,1500,1500,3,RACE_SPELLCASTER,ATTRIBUTE_LIGHT)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and (Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe03,0xa1,1500,1500,3,RACE_SPELLCASTER,ATTRIBUTE_LIGHT)
		or Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe03,0xa1,1500,1500,3,RACE_SPELLCASTER,ATTRIBUTE_LIGHT)) then
		c:AddMonsterAttribute(TYPE_RITUAL+TYPE_EFFECT)
		Duel.SpecialSummonStep(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		c:AddMonsterAttributeComplete()
			--함정 무효 내성 부여
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_INACTIVATE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(cm.effectfilter)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			c:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_DISEFFECT)
			e2:SetRange(LOCATION_MZONE)
			e2:SetValue(cm.effectfilter)
			e2:SetReset(RESET_EVENT+0x1fc0000)
			c:RegisterEffect(e2,true)
			--샐비지
			local e3=Effect.CreateEffect(c)
			e3:SetCategory(CATEGORY_TOHAND)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCode(EVENT_FREE_CHAIN)
			e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCountLimit(1)
			e3:SetCost(YuL.discard(1,1))
			e3:SetTarget(cm.thtg)
			e3:SetOperation(cm.thop)
			e3:SetHintTiming(0,TIMING_END_PHASE)
			e3:SetReset(RESET_EVENT+0x1fc0000)
			c:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end
--함정 무효 내성 부여
function cm.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsType(TYPE_TRAP) and loc&LOCATION_ONFIELD~=0
end
--샐비지
function cm.thfilter(c)
	return (c:IsSetCard(0xe03) and c:IsType(TYPE_TRAP) or c:GetType()==TYPE_SPELL+TYPE_RITUAL) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--바운스
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
