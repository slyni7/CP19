--CytusII BM(Black Market) Lv.15 Capybara Kids' Paradise
function c112600049.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c112600049.matfilter,4,2)
	c:EnableReviveLimit()
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112600049,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCost(c112600049.thcost)
	e2:SetTarget(c112600049.thtg)
	e2:SetOperation(c112600049.thop)
	c:RegisterEffect(e2)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(112600049,3))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c112600049.tdcon)
	e4:SetTarget(c112600049.tdtg)
	e4:SetOperation(c112600049.tdop)
	c:RegisterEffect(e4)
end
function c112600049.matfilter(c)
	return c:IsAttackBelow(2000)
end
function c112600049.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c112600049.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c112600049.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c112600049.thfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(112600049)==0
		and Duel.IsExistingTarget(c112600049.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	local b1=Duel.IsExistingTarget(c112600049.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(c112600049.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(112600049,1),aux.Stringid(112600049,2))
	else
		op=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=nil
	if op==0 then
		g=Duel.SelectTarget(tp,c112600049.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	elseif op==1 then
		g=Duel.SelectTarget(tp,c112600049.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	else
		g=Duel.SelectTarget(tp,c112600049.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c112600049.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c112600049.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c112600049.filter(c,e)
	return c:IsLevel(4) and c:IsCanBeEffectTarget(e) and c:IsAbleToDeck()
end
function c112600049.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c112600049.filter(chkc,e) end
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c112600049.filter,tp,LOCATION_GRAVE,0,nil,e)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,2,2,nil)
		Duel.SetTargetCard(sg)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,2,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	end
end
function c112600049.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()~=2 then return end
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end