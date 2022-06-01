--다원마도서원 라메이슨
function c27183398.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(0)
	e2:SetDescription(aux.Stringid(27183398,0))
	e2:SetTarget(c27183398.tg2)
	e2:SetOperation(c27183398.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetCountLimit(1)
	e3:SetDescription(aux.Stringid(27183398,1))
	e3:SetLabel(1)
	e3:SetCondition(c27183398.con3)
	e3:SetTarget(c27183398.tg3)
	e3:SetOperation(c27183398.op2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(27183398,2))
	e4:SetTarget(c27183398.tg4)
	e4:SetOperation(c27183398.op4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c27183398.con5)
	c:RegisterEffect(e5)
end
function c27183398.tfilter2(c)
	return c:IsSetCard(0x306e) and c:GetCode()~=27183398 and c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c27183398.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	e:SetLabel(0)
	if Duel.IsExistingMatchingCard(c27183398.nfilter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c27183398.tfilter2,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(27183398,0)) then
		e:SetLabel(1)
		c:RegisterFlagEffect(27183398,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(0)
	end
end
function c27183398.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if e:GetLabel()<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c27183398.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,1,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c27183398.nfilter3(c)
	return c:IsRace(RACE_SPELLCASTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c27183398.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27183398.nfilter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c27183398.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(27183398)<1
			and Duel.IsExistingMatchingCard(c27183398.tfilter2,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c27183398.tfilter41(c)
	return c:IsSetCard(0x306e) and c:IsType(TYPE_SPELL)
end
function c27183398.tfilter42(c,e,tp,lv)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27183398.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c27183398.tfilter41,tp,LOCATION_GRAVE,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c27183398.tfilter42,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,ct)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c27183398.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return false
	end
	local ct=Duel.GetMatchingGroupCount(c27183398.tfilter41,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27183398.tfilter42,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,ct)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c27183398.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsReason(REASON_DESTROY)
end