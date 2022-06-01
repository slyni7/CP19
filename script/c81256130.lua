--토용 마유미
--카드군 번호: 0xc9d
local m=81256130
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x02+0x10)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--유언 효과
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--특수 소환
function cm.nfil0(c)
	return c:IsFaceup() and c:IsSetCard(0xc9c)
end
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.nfil0,tp,0x04,0,1,nil)
end
function cm.filter1(c)
	return (c:IsFaceup() or c:IsLocation(0x02)) and c:IsAbleToRemove() and c:IsSetCard(0xc9c) and c:IsType(0x1)
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc9c) and c:IsLevelAbove(5)
end
function cm.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc9c) and c:GetType()==0x2+TYPE_FIELD
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	--condition check
	local b1=Duel.GetMatchingGroup(cm.spfil0,tp,0x01,0,nil,e,tp)
	local b2=Duel.GetMatchingGroup(cm.tfil0,tp,0x01,0,nil)
	local c=e:GetHandler()
	local loc=0
	if #b2>0 then loc=loc+0x0c end
	if not Duel.IsPlayerAffectedByEffect(tp,47355498) then loc=loc+0x10 end
	local ft=Duel.GetLocationCount(tp,0x04)
	if #b1>0 and ft>1 then loc=loc+0x02 end
	--solving effect
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and ft>0
		and Duel.IsExistingMatchingCard(cm.filter1,tp,loc,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,loc)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	--cost check
	local b1=Duel.GetMatchingGroup(cm.spfil0,tp,0x01,0,nil,e,tp)
	local b2=Duel.GetMatchingGroup(cm.tfil0,tp,0x01,0,nil)
	local loc=0
	if #b2>0 then loc=loc+0x0c end
	if not Duel.IsPlayerAffectedByEffect(tp,47355498) then loc=loc+0x10 end
	local ft=Duel.GetLocationCount(tp,0x04)
	if #b1>0 and ft>1 then loc=loc+0x02 end
	local g=Duel.GetMatchingGroup(cm.filter1,tp,loc,0,nil)
	--solving effect
	local c=e:GetHandler()
	if ft<=0 or loc==0 then
		return
	end
	if #g>0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			if tc:IsPreviousLocation(0x02) and ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg2=b1:Select(tp,1,1,nil)
				if #sg2>0 then
					Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
				end
			elseif tc:IsPreviousLocation(0x0c) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg2=b2:Select(tp,1,1,nil)
				if #sg2>0 then
					Duel.SendtoHand(sg2,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg2)
				end
			else 
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.limit_sp0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.limit_sp0(e,c)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(0x40)
end

--유언 효과
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE)
end
function cm.filter2(c)
	return (c:IsFaceup() or c:IsLocation(0x10)) and c:IsSetCard(0xc9c) and c:IsType(0x2+0x4)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.filter2,tp,0x10+0x20,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10+0x20)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,0x10+0x20,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
