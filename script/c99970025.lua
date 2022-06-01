--H. Enchanter: 5
function c99970025.initial_effect(c)

	--링크 소환
	aux.AddLinkProcedure(c,c99970025.matfilter,1)
	c:EnableReviveLimit()

	--오버레이
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970025,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99970025)
	e1:SetTarget(c99970025.target)
	e1:SetOperation(c99970025.operation)
	c:RegisterEffect(e1,false,1)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c99970025.condition1)
	e2:SetTarget(c99970025.target1)
	e2:SetOperation(c99970025.activate1)
	c:RegisterEffect(e2)

end

--링크 소환
function c99970025.matfilter(c)
	return c:GetLevel()==4 and c:IsRace(RACE_SPELLCASTER)
end

--오버레이
function c99970025.filter(c,g)
	return c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN) and g:IsContains(c)
end
function c99970025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99970025.filter(chkc,lg) end
	if chk==0 then return Duel.IsExistingTarget(c99970025.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c99970025.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lg)
end
function c99970025.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end

--서치
function c99970025.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c99970025.filter1(c)
	return c:IsSetCard(0xd33) and c:IsAbleToHand()
end
function c99970025.filter2(c)
	return c:IsSetCard(0xd32) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99970025.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970025.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c99970025.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c99970025.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c99970025.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c99970025.filter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
end


