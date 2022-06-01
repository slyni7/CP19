--기습 해전
function c81180090.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81180090,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81180090+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81180090.tg1)
	e1:SetOperation(c81180090.op1)
	c:RegisterEffect(e1)
	
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81180090,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c81180090.cn2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81180090.tg2)
	e2:SetOperation(c81180090.op2)
	c:RegisterEffect(e2)
end

function c81180090.filter1(c,e,tp)
	return c:GetLevel()==1 and
	c:IsSetCard(0xcb5) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81180090.xfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2)
end
function c81180090.filter2(c,mg,exg)
	return mg:IsExists(c81180090.filter3,1,c,c,exg)
end
function c81180090.filter3(c,mc,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function c81180090.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	local mg=Duel.GetMatchingGroup(c81180090.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c81180090.xfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then
		return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.GetLocationCountFromEx(tp)>0
		and mg:IsExists(c81180090.filter2,1,nil,mg,exg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c81180090.filter2,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c81180090.filter3,1,1,tc1,tc1,exg)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end
function c81180090.filter4(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81180090.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		return
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then
		return
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c81180090.filter4,nil,e,tp)
	if g:GetCount()<2 then
		return
	end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	if Duel.GetLocationCountFromEx(tp,tp,g)<=0 then
		return
	end
	Duel.BreakEffect()
	local xg=Duel.GetMatchingGroup(c81180090.xfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xm=xg:Select(tp,1,1,nil):GetFirst()
		if Duel.XyzSummon(tp,xm,g)~=0 and Duel.SelectYesNo(tp,aux.Stringid(81180090,1)) then
			c:CancelToGrave()
			Duel.Overlay(xm,Group.FromCards(c))
			xm:CompleteProcedure()
		end
	end
end

--xyz
function c81180090.cn2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ( ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE )
end
function c81180090.sfilter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xcb5) and c:IsType(TYPE_XYZ)
	and Duel.GetLocationCountFromEx(tp,tp,c)>-1
	and Duel.IsExistingMatchingCard(c81180090.sfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1)
end
function c81180090.sfilter3(c,e,tp,mc,rk)
	return c:GetRank()==rk and c:IsSetCard(0xcb5) 
	and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c81180090.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c81180090.filter2(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81180090.sfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81180090.sfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c81180090.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then
		return
	end
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81180090.sfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end


