--[Forest]
local m=99970506
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환 + 카운터
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(YuL.LPcost(1000))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

end

--특수 소환 + 카운터
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xe0c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.ctfil(c)
	return c:IsFaceup() and c:IsCode(99970501)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(cm.ctfil,tp,LOCATION_ONFIELD,0,nil)
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)+1
		local cc=g:GetFirst()
		while cc do
			cc:AddCounter(0x1052,ct,REASON_EFFECT)
			cc=g:GetNext()
		end
	end
end
