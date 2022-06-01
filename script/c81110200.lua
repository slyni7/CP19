--진벌의 가랑잎발파
--카드군 번호: 0xcae
local m=81110200
local cm=_G["c"..m]
function cm.initial_effect(c)

	--유발 효과(패)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(0x02)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--유발 즉시(묘지)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e2)
end

cm.counter_add_list={0x1011}

--특수 소환, loc 0x02
function cm.nfilter1(c,tp)
	return c:IsFaceup() and c:IsOnField() and c:IsControler(tp) and c:IsSetCard(0xcae)
end
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return false
	end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	e:SetLabelObject(tg)
	return tg and tg:IsExists(cm.nfilter1,1,nil,tp)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=e:GetLabelObject()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and ec and Duel.GetLocationCount(tp,0x04)>0
	end
	Duel.SetTargetCard(ec)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ec,#ec,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x0c)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if c:IsRelateToEffect(e) then
		while ec do
			local ct=Duel.Destroy(ec,REASON_EFFECT)
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0x0c,0,nil)
			if #g>0 and ct>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then			
				for i=1,ct do
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
					local sg=g:Select(tp,1,1,nil)
					sg:GetFirst():AddCounter(0x1011,1)
				end
			end
		end
	end
end

--특수 소환, loc 0x10
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.tfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xcae) and Duel.GetMZoneCount(tp,c)>0
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(tp) and cm.tfilter1(chkc,tp)
	end
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(cm.tfilter1,tp,0x0c,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.tfilter1,tp,0x0c,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x0c)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(0x20)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0x0c,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local sg=g:Select(tp,1,1,nil)
			sg:GetFirst():AddCounter(0x1011,2)
		end
	end
end
