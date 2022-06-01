--일러스크립트레이션
function c27182824.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(c27182824.tg1)
	e1:SetOperation(c27182824.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1,27182824)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCost(c27182824.cost2)
	e2:SetTarget(c27182824.tg2)
	e2:SetOperation(c27182824.op2)
	c:RegisterEffect(e2)
end
function c27182824.tfilter11(c,e,tp,m)
	if not c:IsSetCard(0x2c2)
		or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then
		return false
	end
	local mg=m
	mg:RemoveCard(c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return mg:CheckWithSumGreater(c27182824.tfunction1,c:GetLevel(),c)
end
function c27182824.tfilter12(c,r,l,m)
	local s=c27182824.tfunction1(c,r)
	local s1=bit.band(s,0xffff)
	local s2=bit.rshift(s,16)
	local mg=m
	mg:RemoveCard(c)
	return mg:CheckWithSumGreater(c27182824.tfunction1,l-s,r) or l<s1 or l<s2
end
function c27182824.tfunction1(c,r)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	else
		return c:GetRitualLevel(r)
	end
end
function c27182824.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local m=Duel.GetRitualMaterial(tp)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
		local m2=Group.CreateGroup()
		local tc=g:GetFirst()
		while tc do
			local og=tc:GetOverlayGroup()
			if og then
				m2:Merge(og)
			end
			tc=g:GetNext()
		end
		m:Merge(g)
		m:Merge(m2)
		return Duel.IsExistingMatchingCard(c27182824.tfilter11,tp,LOCATION_HAND,0,1,nil,e,tp,m)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c27182824.op1(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local m2=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local og=tc:GetOverlayGroup()
		if og then
			m2:Merge(og)
		end
		tc=g:GetNext()
	end
	m:Merge(g)
	m:Merge(m2)
	local tg=Duel.SelectMatchingCard(tp,c27182824.tfilter11,tp,LOCATION_HAND,0,1,1,nil,e,tp,m)
	local tc=tg:GetFirst()
	if tc then
		m:Sub(tg)
		if tc.mat_filter then
			m=m:Filter(tc.mat_filter,nil)
		end
		local lv=tc:GetLevel()
		local mat=Group.CreateGroup()
		repeat
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local rg=m:FilterSelect(tp,aux.TRUE,1,1,nil)
			local rc=rg:GetFirst()
			lv=lv-c27182824.tfunction1(rc,tc)
			m:Sub(rg)
			mat:Merge(rg)
		until bit.band(lv,0x8000)==0x8000 or bit.band(lv,0xffff)==0
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
		mat:Sub(mat2)
		Duel.SendtoGrave(mat,REASON_RELEASE+REASON_RITUAL+REASON_MATERIAL+REASON_EFFECT)
		Duel.ReleaseRitualMaterial(mat2)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c27182824.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
			and Duel.IsExistingTarget(c27182824.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c)
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c27182824.tfilter2(c)
	return c:IsSetCard(0x2c2)
		and (c:IsFaceup()
			or c:IsLocation(LOCATION_GRAVE))
		and c:IsAbleToHand()
end
function c27182824.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
			and c27182824.tfilter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27182824.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27182824.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27182824.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end