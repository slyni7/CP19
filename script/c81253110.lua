--비의 - 마타라 두카
--카드군 번호: 0xc80 0x1c80 0x2c80
local m=81253110
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--패에서
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.cn2)
	c:RegisterEffect(e2)
	
	--소환 제한
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPF_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.cn3)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(cm.op6)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_NEGATED)
	e7:SetOperation(cm.op7)
	c:RegisterEffect(e7)
	
	--퍼미션
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.cn4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	local e8=e4:Clone()
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e8)
	
	--자괴
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_SELF_TOGRAVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(cm.cn5)
	c:RegisterEffect(e5)
end

--패에서
function cm.nfil0(c)
	return c:IsFaceup() and c:IsCode(81253000)
end
function cm.cn2(e)
	local tp=e:GetHandler():GetControler()
	local ct=Duel.GetMatchingGroupCount(cm.nfil0,tp,0x0c,0x0c,nil)
	return ct>0
end

--소환 제한
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		return
	end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.op7(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		return
	end
	e:GetHandler():ResetFlagEffect(m)
end
function cm.nfil1(c,tp)
	return c:GetOwner()==tp
end
function cm.cn3(e,c)
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():GetFlagEffect(m)~=0
	and Duel.GetMatchingGroupCount(cm.nfil1,tp,0,LOCATION_MZONE,nil,tp)
end

--퍼미션
function cm.cn4(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
end
function cm.tfil0(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x1c80)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x10,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x10)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x10,0,1,1,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end

--자괴
function cm.nfil2(c)
	return c:IsFaceup() and c:IsCode(81253000)
end
function cm.cn5(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY
	and not Duel.IsExistingMatchingCard(cm.nfil2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
