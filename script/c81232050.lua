--기연 멀티플리케이티브 헤드
--카드군 번호: 0xcba
local m=81232050
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--묘지 유발
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--제외 및 특수 소환
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.cfilter1(c,tp)
	return c:GetLevel()>0 and c:IsReleasable() and c:IsRace(RACE_ZOMBIE)
	and Duel.IsExistingMatchingCard(cm.tfilter1,tp,0x01,0,1,nil,c:GetLevel())
end
function cm.tfilter1(c,lv)
	return c:IsAbleToRemove() and c:IsSetCard(0x1cba) and c:IsType(0x1) and c:GetLevel()~=lv
end
function cm.filchk(c)
	return c:IsFaceup() and c:IsCode(81232080)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then
			return false
		end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,cm.cfilter1,1,nil,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,cm.cfilter1,1,1,nil,tp)
	e:SetValue(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01+0x02+0x10)
	if Duel.IsExistingMatchingCard(cm.filchk,tp,0x0c+0x10,0,1,nil) then
		Duel.SetChainLimit(cm.chlimit)
	end
end
function cm.chlimit(e,ep,tp)
	return ep==tp
end
function cm.spfilter1(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
	and c:IsCode(code)
end
function cm.sp(g,tp,pos)
	local sc=g:GetFirst()
	while sc do
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,pos)
		sc=g:GetNext()
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.tfilter1,tp,0x01,0,1,1,nil,e:GetValue())
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local ft=Duel.GetLocationCount(tp,0x04)
		if ft>0 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local cg=Group.CreateGroup()
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter1),tp,0x01+0x02+0x10,0,nil,e,tp,tc:GetCode())
		if ft>0 and tc:IsFaceup() and tc:IsLocation(0x20) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			if #mg<=ft then
				cm.sp(mg,tp,POS_FACEUP_ATTACK)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local fg=mg:Select(tp,ft,ft,nil)
				cm.sp(fg,tp,POS_FACEUP_ATTACK)
				mg:Sub(fg)
				cg:Merge(g)
			end
		end
	end
	Duel.SpecialSummonComplete()
end

--세트 및 덱 회수
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsType(0x4) and rc:IsSetCard(0x2cba) 
end
function cm.tfilter2(c)
	return c:IsSSetable() and c:IsSetCard(0x1cba) and c:IsType(0x1)
	and (c:IsLocation(0x10) or c:IsFaceup())
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(cm.tfilter2,tp,0x10+0x20,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tfilter2),tp,0x10+0x20,0,1,1,nil)
	if #g>0 and Duel.SSet(tp,g)~=0 then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end