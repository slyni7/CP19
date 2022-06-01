--귀정 니와타리진
--카드군 번호: 0xc8c
local m=81237040
local cm=_G["c"..m]
function cm.initial_effect(c)

	aux.EnableDualAttribute(c)
	
	--공통 효과
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetRange(0x04)
	e1:SetCondition(aux.IsDualState)
	e1:SetValue(cm.va1)
	c:RegisterEffect(e1)
	
	--강제 공격
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(0x04)
	e2:SetTargetRange(0,0x04)
	e2:SetCondition(aux.IsDualState)
	c:RegisterEffect(e2)
	
	--데미지를 준다
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(0x04)
	e3:SetCountLimit(1,m+1+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--특수 소환
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(0x02)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.cn4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end

--전투 데미지 반사
function cm.va1(e,c)
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

--데미지를 준다
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetLP(tp)-Duel.GetLP(1-tp)>=3000
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetTargetPlayer(1-tp)
	local dam=0
	if Duel.GetLP(tp)>Duel.GetLP(1-tp) then dam=Duel.GetLP(tp)-Duel.GetLP(tp) end	
	Duel.SetOperation(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAINIFO_TARGET_PLAYER)
	local val=Duel.GetLP(tp)-Duel.GetLP(1-tp)
	if val>0 then
		Duel.Damage(p,val,REASON_EFFECT)
	end
end

--특수 소환
function cm.nfil0(c,tp)
	return (c:IsReason(REASON_BATTLE) or c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT))
	and c:IsPreviousLocation(0x04) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0xc8c) and c:IsType(0x1)
end
function cm.cn4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil0,1,nil,tp)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spfil0(c,e,tp,eg)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and eg:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		c:EnableDualState()
		local g=eg:Filter(cm.nfil0,nil,tp)
		local og=Duel.GetMatchingGroup(cm.spfil0,tp,0x01+0x02+0x10,0,nil,e,tp,g)
		if #og>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=og:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				tc:EnableDualState()
			end
		end
	end
	Duel.SpecialSummonComplete()
end
