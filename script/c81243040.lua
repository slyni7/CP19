--이형의 계시
--카드군 번호: 0xc86
local m=81243040
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	c:EnableReviveLimit()
	c:EnableCounterPermit(0xc86)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc86),3,2,cm.xyzfil0,aux.Stringid(m,0),99,cm.xyzop)

	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--전투 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(cm.effcon)
	e2:SetValue(1)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	
	--제외 불가
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetRange(0x04)
	e4:SetTargetRange(1,1)
	e4:SetCondition(cm.effcon)
	e4:SetLabel(2)
	c:RegisterEffect(e4)
	
	--공격력 / 수비력
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(0x04)
	e5:SetCondition(cm.effcon)
	e5:SetValue(cm.atkval)
	e5:SetLabel(3)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
	
	--대상 내성
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetRange(0x04)
	e7:SetCondition(cm.effcon)
	e7:SetValue(aux.tgoval)
	e7:SetLabel(5)
	c:RegisterEffect(e7)
	
	--호러 카운터
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_COUNTER)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetRange(0x04)
	e8:SetCountLimit(1)
	e8:SetCondition(cm.effcon2)
	e8:SetCost(cm.co8)
	e8:SetTarget(cm.tg8)
	e8:SetOperation(cm.op8)
	e8:SetLabel(7)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(0x04)
	e9:SetOperation(cm.op9)
	c:RegisterEffect(e9)
end

--엑시즈 소환
function cm.xyzfil0(c)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsSetCard(0xc86) and not c:IsCode(m)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m)==0
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

--서치
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and ( c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp )
end
function cm.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc86) and c:IsType(0x2+0x4)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	local c=e:GetHandler()
	if tc:IsType(TYPE_QUICKPLAY) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		e1:SetRange(0x02)
		tc:RegisterEffect(e1)
	end
	if tc:IsType(0x4) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		e2:SetRange(0x02)
		tc:RegisterEffect(e2)
	end
end

--엑시즈 소재의 수에 따라 적용
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function cm.effcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=e:GetLabel()
	and tp~=Duel.GetTurnPlayer()
end
function cm.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function cm.co8(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,3,REASON_COST)
	end
	c:RemoveOverlayCard(tp,3,3,REASON_COST)
end
function cm.tg8(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsCanAddCounter(0xc86,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc86)
end
function cm.op8(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0xc86,1)
	end
end
function cm.op9(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCounter(0xc86)==3 then
		Duel.Win(tp,0xc8)
	end
end
