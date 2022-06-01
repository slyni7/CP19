--CytusII BM(Black Market) Lv.14 Ramen is God
function c112600052.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xe7e),4,3,c112600052.ovfilter,aux.Stringid(112600052,0),99,c112600052.xyzop)
	c:EnableReviveLimit()
	--cannot spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112600052,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1)
	e3:SetCost(c112600052.dcost)
	e3:SetCondition(c112600052.dcon)
	e3:SetOperation(c112600052.dop)
	c:RegisterEffect(e3)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetDescription(aux.Stringid(112600052,2))
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c112600052.rmcon)
	e2:SetTarget(c112600052.rmtg)
	e2:SetOperation(c112600052.rmop)
	c:RegisterEffect(e2)
	--shuffle
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetDescription(aux.Stringid(112600052,3))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetTarget(c112600052.target)
	e1:SetOperation(c112600052.operation)
	c:RegisterEffect(e1)
end
function c112600052.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe7e) and not c:IsCode(112600052)
end
function c112600052.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,112600052)==0 end
	Duel.RegisterFlagEffect(tp,112600052,RESET_PHASE+PHASE_END,0,1)
end
function c112600052.cfilter0(c)
	return c:IsSetCard(0xe7c) and c:IsAbleToGraveAsCost()
end
function c112600052.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112600052.cfilter0,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c112600052.cfilter0,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c112600052.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c112600052.dop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c112600052.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c112600052.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_HAND+LOCATION_DECK)
end
function c112600052.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c112600052.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>2
		and Duel.IsPlayerCanRemove(1-tp) end
end
function c112600052.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c112600052.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanRemove(1-tp) then return end
	local g=Duel.GetMatchingGroup(c112600052.rmfilter,1-tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,3,3,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c112600052.filter(c)
	return c:IsSetCard(0xe7c) and c:IsAbleToDeck()
end
function c112600052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c112600052.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c112600052.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c112600052.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c112600052.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=1 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==1 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end