--IJN 미카사
function c81190000.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(c81190000.mat1),aux.FilterBoolFunction(Card.IsAttackAbove,2000),2,true)

	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81190000,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,81190000+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c81190000.cn2)
	e2:SetTarget(c81190000.tg2)
	e2:SetOperation(c81190000.op2)
	c:RegisterEffect(e2)
	
	--rdeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81190000,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c81190000.tg3)
	e3:SetOperation(c81190000.op3)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	c:RegisterEffect(e3)
end

--material
function c81190000.mat1(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xcb6)
end

--remove
function c81190000.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c81190000.filter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81190000.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_SZONE+LOCATION_GRAVE
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81190000.filter,tp,loc,loc,1,nil)
	end
	local g=Duel.GetMatchingGroup(c81190000.filter,tp,loc,loc,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c81190000.lm1)
end
function c81190000.lm1(e,ep,tp)
	return tp==ep
end
function c81190000.op2(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_SZONE+LOCATION_GRAVE
	local g=Duel.GetMatchingGroup(c81190000.filter,tp,loc,loc,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

--rdeck
function c81190000.filter1(c)
	return c:IsFaceup() and c:IsAbleToDeck() and c:IsSetCard(0xcb6)
end
function c81190000.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c81190000.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81190000.filter1,tp,LOCATION_REMOVED,0,3,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81190000.filter1,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
end
function c81190000.op3(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then
		return
	end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
	end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	local cg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if ct==3 
	and cg:GetCount()>0
	and Duel.SelectYesNo(tp,aux.Stringid(81190000,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=cg:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end


