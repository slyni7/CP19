--[ Episode# ]
local s,id=GetID()
function s.initial_effect(c)

	--1
	local e1=MakeEff(c,"STo")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCL(1,id)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	--2
	local e3=MakeEff(c,"FTo","G")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCL(1,{id,1})
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	
end

--1
function s.tar1fil(c)
	return c:IsSetCard(0x5d6e) and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tar1fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.tar1fil,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--2
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
