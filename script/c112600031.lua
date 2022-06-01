--CytusII Lv.15 Re:incRnaTiØN ~夕焼ケ世界ノ決別ヲ~
function c112600031.initial_effect(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(112600031,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCost(c112600031.spcost0)
	e0:SetTarget(c112600031.sptg0)
	e0:SetOperation(c112600031.spop0)
	c:RegisterEffect(e0)
	--excavate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112600031,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c112600031.thtg)
	e2:SetOperation(c112600031.thop)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112600031,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,112600031)
	e1:SetCost(c112600031.spcost)
	e1:SetTarget(c112600031.sptg)
	e1:SetOperation(c112600031.spop)
	c:RegisterEffect(e1)
end
function c112600031.spcost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c112600031.spfilter0(c,e,tp)
	return c:IsSetCard(0x1e7e) and not c:IsCode(112600031) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112600031.sptg0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c112600031.spfilter0(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c112600031.spfilter0,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c112600031.spfilter0,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c112600031.spop0(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c112600031.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,c)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c112600031.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		if g:IsExists(Card.IsSetCard,1,nil,0xe7e) then
			if Duel.SelectYesNo(tp,aux.Stringid(112600031,2)) then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,Card.IsSetCard,1,2,nil,0xe7e)
				if sg:GetFirst():IsAbleToHand() then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(2-tp,sg)
					Duel.ShuffleHand(tp)
				end
			end
			if tc:IsRelateToEffect(e) then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end
function c112600031.costfilter(c)
	return c:IsSetCard(0xe7e) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c112600031.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,148244724)}) do
		fg:AddCard(pe:GetHandler())
	end
	local loc=LOCATION_HAND
	if fg:GetCount()>0 then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c112600031.costfilter,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c112600031.costfilter,tp,loc,0,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		local fc=nil
		if fg:GetCount()==1 then
			fc=fg:GetFirst()
		else
			fc=fg:Select(tp,1,1,nil)
		end
		Duel.Hint(HINT_CARD,0,fc:GetCode())
		fc:RegisterFlagEffect(148244724,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
	Duel.SendtoGrave(tc,REASON_COST)
end
function c112600031.spfilter(c,e,tp)
	return c:IsSetCard(0xe7e) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c112600031.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and chkc:IsControler(tp) and c112600031.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c112600031.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c112600031.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c112600031.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end