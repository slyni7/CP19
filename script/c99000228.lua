--파인딩 더 미싱 게이트
local m=99000228
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(2,m)
	e2:SetCondition(cm.condition)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.ctfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_ORDER) and c:IsControler(tp)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.ctfilter,1,nil,tp)
end
function cm.filter3(c,e,tp)
	return c:IsLevelBelow(5) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(cm.ctfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_SPECIAL) and Duel.IsPlayerCanDraw(tp,1)
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		local sg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_HAND,0,nil,e,tp)
		if tc:IsSummonType(SUMMON_TYPE_ORDER_L) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg:GetCount()>0
			and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local gc=sg:Select(tp,1,1,nil):GetFirst()
			local spos=0
			if gc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) then spos=spos+POS_FACEUP_ATTACK end
			if gc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
			Duel.SpecialSummon(gc,0,tp,tp,false,false,spos)
		end
		if tc:IsSummonType(SUMMON_TYPE_ORDER_R) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
			local sc=g:GetFirst()
			while sc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(500)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				sc:RegisterEffect(e2)
				sc=g:GetNext()
			end
		end
		tc=g:GetNext()
	end
end