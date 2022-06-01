--네파시아 어웨이큰
function c47550016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,47550016+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c47550016.target)
	e1:SetOperation(c47550016.activate)
	c:RegisterEffect(e1)
end

function c47550016.filter(c,e,tp)
	return c:IsSetCard(0x487) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c47550016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)

	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c47550016.filter(chkc,e,tp) end

	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c47550016.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end

	local ct=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ct>2 then ct=2 end

	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>2 or (Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<3 and not Duel.SelectYesNo(tp,aux.Stringid(47550016,0))) then ct=1 end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c47550016.filter,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end

function c47550016.lfilter(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x487)
end

function c47550016.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(c47550016.filter,nil,e)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end

	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c47550016.lfilter,tp,LOCATION_EXTRA,0,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(47550016,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c47550016.lfilter,tp,	LOCATION_EXTRA,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.LinkSummon(tp,tc,nil)
			end
		end
	end
end