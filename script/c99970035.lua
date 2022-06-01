--H. Enchantment: Overseer
function c99970035.initial_effect(c)

	--서치
	local ex=Effect.CreateEffect(c)
	ex:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	ex:SetCountLimit(1,99970035)
	ex:SetType(EFFECT_TYPE_ACTIVATE)
	ex:SetCode(EVENT_FREE_CHAIN)
	ex:SetTarget(c99970035.target)
	ex:SetOperation(c99970035.activate)
	c:RegisterEffect(ex)
	
	--솔라
	local ey=Effect.CreateEffect(c)
	ey:SetType(EFFECT_TYPE_SINGLE)
	ey:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ey:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	ey:SetRange(LOCATION_MZONE)
	ey:SetCondition(c99970035.solarcon)
	ey:SetValue(aux.tgoval)
	c:RegisterEffect(ey)
	
	--루나
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970035,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c99970035.lunarcon)
	e1:SetCost(c99970035.spcost)
	e1:SetTarget(c99970035.sptg)
	e1:SetOperation(c99970035.spop)
	c:RegisterEffect(e1)
	
	--테라
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99970035,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(c99970035.terracon)
	e2:SetTarget(c99970035.drtg)
	e2:SetOperation(c99970035.drop)
	c:RegisterEffect(e2)
	
end

--서치
function c99970035.thfilter(c)
	return c:IsSetCard(0xd32) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99970035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970035.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970035.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99970035.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--속성 필터
function c99970035.solarfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_FIRE)
end
function c99970035.lunarfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND+ATTRIBUTE_DARK)
end
function c99970035.terrafilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_EARTH)
end

--솔라
function c99970035.solarcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99970035.solarfilter,tp,LOCATION_MZONE,0,1,nil)
end

--루나
function c99970035.lunarcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99970035.lunarfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99970035.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c99970035.spfilter(c,e,tp)
	return c:IsSetCard(0xd32) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970035.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99970035.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c99970035.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c99970035.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99970035.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--테라

function c99970035.scfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd32) and c:IsControler(tp)
end
function c99970035.terracon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99970035.scfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c99970035.terrafilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99970035.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99970035.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
