--프리즈스타의 옹알이 천사
--카드군 번호: 0xc81
local m=81252040
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	
	--스탯
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(0x04)
	e1:SetValue(cm.va1)
	c:RegisterEffect(e1)
	
	--표시 형식
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x04)
	e2:SetCountLimit(1)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	c:RegisterEffect(e2)
	
	--특수 소환
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_FLIP)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--스탯
function cm.tfil0(c,tp)
	return c:IsFaceup() and c:GetOwner()==tp
end
function cm.va1(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x04,0,nil,1-tp)
	local ct=g:GetSum(Card.GetLevel)
	if g:IsExists(Card.IsType,1,nil,TYPE_XYZ) then
		local ct2=g:GetSum(Card.GetRank)
		ct=ct+ct2
	end
	return ct*300
end

--표시 형식
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0x02,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0x02,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.posfil0(c)
	return c:IsFacedown()
end
function cm.posfil1(c)
	return c:IsCanTurnSet()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.posfil0,tp,0x04,0x04,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.posfil1,tp,0x04,0x04,1,nil)
	if chk==0 then
		return b1 or b2
	end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	e:SetLabel(s)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,cm.posfil0,tp,0x04,0x04,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEUP_ATTACK)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,cm.posfil1,tp,0x04,0x04,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEDOWN_DEFENSE)
		end
	end
end

--특수 소환
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x10) and chkc:IsControler(1-tp) and cm.spfil0(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(cm.spfil0,tp,0,0x10,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfil0),tp,0,0x10,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end

