--[ Episode# ]
local s,id=GetID()
function s.initial_effect(c)

	--1
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCL(1,id)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--2
	local e2=MakeEff(c,"STo")
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e1:SetCL(1,{id,1})
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)

end

--1
function s.tar1fil(c,e,tp)
	return c:IsSetCard(0x5d6e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return s.tar1fil(chkc,e,tp) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(s.tar1fil,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectTarget(tp,s.tar1fil,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc+Group.FromCards(c),3,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetCards(e)
	if #tg>0 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>2 
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		tg:AddCard(c)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end

--2
function s.tar2fil(c)
	return c:IsSetCard(0x5d6e) and c:IsM() and c:IsAbleToHand()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tar2fil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tar2fil),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
