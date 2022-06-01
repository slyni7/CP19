--예능의 펜듈럼디스코
function c29160018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29160018+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29160018.target)
	e1:SetOperation(c29160018.activate)
	c:RegisterEffect(e1)
end
function c29160018.filter(c,e,tp,b1)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x2c7) and not c:IsForbidden()
		and (b1 or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c29160018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local g=Duel.GetMatchingGroup(c29160018.filter,tp,LOCATION_DECK,0,nil,e,tp,b1)
	if chk==0 then return (b1 or b2) and g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c29160018.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if not b1 and not b2 then return end
	local g=Duel.GetMatchingGroup(c29160018.filter,tp,LOCATION_DECK,0,nil,e,tp,b1)
	if g:GetClassCount(Card.GetCode)<2 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg2=g:Select(tp,1,1,nil)
	sg:Merge(sg2)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleDeck(tp)
	local cg=sg:Select(1-tp,1,1,nil)
	local tc=cg:GetFirst()
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	if b1 and (not b2 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.SelectYesNo(tp,aux.Stringid(29160018,0))) then
		local tg=Group.FromCards(tc)
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		Duel.RaiseSingleEvent(tc,EVENT_DESTROY,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
		Duel.RaiseEvent(tg,EVENT_DESTROY,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
		Duel.RaiseSingleEvent(tc,EVENT_DESTROYED,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
		Duel.RaiseEvent(tg,EVENT_DESTROYED,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	sg:RemoveCard(tc)
	local b3=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if b3 and Duel.SelectYesNo(tp,aux.Stringid(29160018,0)) then
		local sc=sg:GetFirst()
		Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		Duel.RaiseSingleEvent(sc,EVENT_DESTROY,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
		Duel.RaiseEvent(sg,EVENT_DESTROY,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
		Duel.RaiseSingleEvent(sc,EVENT_DESTROYED,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
		Duel.RaiseEvent(sg,EVENT_DESTROYED,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
	else
		Duel.SendtoExtraP(sg,nil,REASON_EFFECT+REASON_DESTROY)
	end
end