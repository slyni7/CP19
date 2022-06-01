--성령화의 여행자
--카드군 번호: 0x307a
local m=81244080
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(cm.synfil0),1)
	
	--소환 제약
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(cm.co1)
	c:RegisterEffect(e1)
	
	--프리 체인
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x04)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e2)
	
	--특수 소환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMOM)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--소환
function cm.synfil0(c)
	return c:IsAttribute(0x08) and c:IsRace(RACE_FAIRY)
end
function cm.cfil0(c)
	return c:IsFaceup() and c:IsSetCard(0x307a)
end
function cm.co1(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_SYNCHRO)~=SUMMON_TYPE_SYNCHRO then
		return true
	end
	return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x20,0,1,nil)
end

--덱으로 되돌린다
function cm.cosel(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x307a)
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0x0c+0x10,0,nil)
	if chk==0 then
		return g:CheckSubGroup(cm.cosel,2,2)
	end
	local rg=g:SelectSubGroup(tp,cm.cosel,false,2,2)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,0,0x0c,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,0x0c,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end

--특수 소환
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsReason(REASON_COST) and rc:IsSetCard(0x307a) then
		e:SetLabel(1)
	end
	return c:IsPreviousLocation(0x10+0x0c)
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsAttribute(0x08)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x02,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMOM,nil,1,tp,0x02)
end
function cm.ofil0(c)
	return c:IsSynchroSummonable(nil) and c:IsAttribute(0x08)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x02,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 and e:
	GetLabel()==1 then
		local syng=Duel.GetMatchingGroup(cm.ofil0,tp,0x40,0,nil)
		if #syng>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=syng:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil)
		end
	end
end
