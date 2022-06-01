--지옥관문지기 쿠타카(니와타리 쿠타카)
--카드군 번호: 0xc8c
local m=81237000
local cm=_G["c"..m]
function cm.initial_effect(c)

	aux.EnableDualAttribute(c)
	
	--듀얼 몬스터 1장을 릴리스하고 어드밴스 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.cn1)
	e1:SetOperation(cm.op1)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	
	--공통 효과
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e3:SetRange(0x04)
	e3:SetCondition(aux.IsDualState)
	e3:SetValue(cm.va3)
	c:RegisterEffect(e3)
	
	--전투파괴 내성
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(0x04)
	e4:SetCondition(aux.IsDualState)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	
	--LP 회복
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetRange(0x04)
	e6:SetCondition(cm.cn6)
	e6:SetOperation(cm.op6)
	c:RegisterEffect(e6)
	
	--어드밴스 소환
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SUMMON)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(0x02)
	e7:SetCondition(cm.cn7)
	e7:SetCost(cm.co7)
	e7:SetTarget(cm.tg7)
	e7:SetOperation(cm.op7)
	e7:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e7)
end

--어드밴스 소환
function cm.mfil0(c)
	return c:IsType(TYPE_DUAL)
end
function cm.cn1(e,c,minc)
	if c==nil then
		return true
	end
	local mg=Duel.GetMatchingGroup(cm.mfil0,0,0x04,0x04,nil)
	return c:IsLevelAbove(5) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.mfil0,0,0x04,0x04,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end

--전투 데미지 반사
function cm.va3(e,c)
	if e:GetHandler():GetFlagEffect(m)~=0 then
		Duel.RegisterFlagEffect(e:GetHandlerPlayer(),m,RESET_PHASE+PHASE_END,0,1)
		e:GetHandler():ResetFlagEffect(m)
		return true
	elseif Duel.GetFlagEffect(e:GetHandlerPlayer(),m)==0 then
		e:GetHandler():RegisterFlagEffect(m,0,0,1)
		return true
	else
		return false
	end
end

--라이프 회복
function cm.nfil0(c,tp)
	return c:IsPreviousLocation(0x0c) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
	and c:IsPreviousSetCard(0xc8c) and c:IsType(0x1) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.cn6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(cm.nfil0,1,nil,tp) and (not c:IsDisabled() and c:IsDualState())
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(cm.nfil0,nil,tp)
	local val=lg:GetSum(Card.GetBaseDefense)
	Duel.Recover(tp,val,REASON_EFFECT)
end

--어드밴스 소환
function cm.cn7(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc8c)
end
function cm.co7(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x10,0,2,nil)
		and c:GetFlagEffect(m+1)==0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x10,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	c:RegisterFlagEffect(m+1,RESET_CHAIN,0,1)
end
function cm.tg7(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsSummonable(true,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xc8c)
end
function cm.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL)
end
function cm.op7(e,tp,eg,p,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSummonable(true,nil) and Duel.Summon(tp,c,true,nil) then
		local ct=Duel.IsExistingMatchingCard(cm.filter1,tp,0x20,0,4,nil)
		if ct then
			local sg=Duel.GetMatchingGroup(cm.filter2,tp,0x04,0,nil)
			local tc=sg:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetCode(EFFECT_DUAL_STATUS)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			tc=sg:GetNext()
		end
	end
end

		