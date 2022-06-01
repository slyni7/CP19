--MNF(비시아 큐리아) 르 말랭 μ
--카드군 번호: 0x2cb9(호교 기사단)
local m=81210160
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:SetSPSummonOnce(m)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.mfil0,1,1)
	
	--위치 이동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--추가 펜듈럼 소환
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.cn1)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--링크 소재
function cm.mfil0(c)
	return c:IsLinkSetCard(0xcb9) and c:IsLinkType(TYPE_PENDULUM)
end

--위치 이동
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,0x04,PLAYER_NONE,0)>0
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) 
	or Duel.GetLocationCount(tp,0x04,PLAYER_NONE,0)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local zone=Duel.SelectDisableField(tp,1,0x04,0,0)
	local seq=math.log(zone,2)
	Duel.MoveSequence(c,seq)
end

--추가 펜듈럼 소환
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.o2va1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.o2va1(e,c)
	return c:IsSetCard(0xcb9) or c:IsSetCard(0xcff)
end
