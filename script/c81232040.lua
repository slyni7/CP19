--기연 비래
--카드군 번호: 0xcba
local m=81232040
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
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

--특수 소환
function cm.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x1cba)
end
function cm.filchk(c)
	return c:IsFaceup() and c:IsCode(81232080)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0x01+0x02
	if not Duel.IsExistingMatchingCard(cm.filchk,tp,0x0c+0x10,0,1,nil) then loc=0x02 end
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.ofilter1(c)
	return c:IsSSetable() and c:IsSetCard(0x2cba) and c:IsType(0x4)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)<=0 then
		return
	end
	local loc=0x01+0x02
	if not Duel.IsExistingMatchingCard(cm.filchk,tp,0x0c+0x10,0,1,nil) then loc=0x02 end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,loc,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g2=Duel.GetMatchingGroup(cm.ofilter1,tp,0x01,0,nil)
		if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g2:Select(tp,1,1,nil):GetFirst()
			if sg then
				Duel.SSet(tp,sg)
			end
		end
	end
end

--세트 및 덱 회수
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsType(0x4) and rc:IsSetCard(0x2cba) 
end
function cm.tfilter1(c)
	return c:IsSSetable() and c:IsSetCard(0x1cba) and c:IsType(0x1)
	and (c:IsLocation(0x10) or c:IsFaceup())
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(cm.tfilter1,tp,0x10+0x20,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tfilter1),tp,0x10+0x20,0,1,1,nil)
	if #g>0 and Duel.SSet(tp,g)~=0 then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end
