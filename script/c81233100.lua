--황혼의 교단
--카드군 번호: 0xc70
local m=81233100
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--지속 효과
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(0x100)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--기동 효과
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(0x10)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--효과 처리
function cm.tfilter1(c)
	return c:IsSetCard(0xc70) and not c:IsCode(m)
	and ( c:IsAbleToGrave() or c:IsAbleToRemove() )
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GetMatchingGroup(cm.tfilter1,tp,0x01,0,nil)
	if #g>0 and not Duel.IsExistingMatchingCard(aux.TRUE,tp,0x0c,0,1,c)
	and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end

--체인 불가
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if ep==tp and re:IsActiveType(0x1) 
	and tc:IsType(TYPE_SYNCHRO) and tc:IsRace(RACE_WINDBEAST) and tc:IsLevelAbove(8) then
		Duel.SetChainLimit(cm.val)
	end
end
function cm.val(e,rp,tp)
	return tp==rp
end

--특수 소환
function cm.tfilter2(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and (c:IsType(TYPE_SYNCHRO) or c:IsSetCard(0xc8f))
	and Duel.IsExistingMatchingCard(cm.spfilter1,tp,0x10,0,1,nil,e,tp,lv)
end
function cm.spfilter1(c,e,tp,lv)
	return c:GetLevel()>0 and c:GetLevel()~=lv and c:IsRace(RACE_WINDBEAST)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x04) and chkc:IsControler(tp) and cm.tfilter2(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingTarget(cm.tfilter2,tp,0x04,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tfilter2,tp,0x04,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x10)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local g=Duel.GetMatchingGroup(cm.spfilter1,tp,0x10,0,nil,e,tp,tc:GetLevel())
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
