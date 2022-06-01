--밤 그림자 카스미(야에 사쿠라)
--카드군 번호: 0xcbc
local m=81230110
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableCounterPermit(0xcbc)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),4,2)
	
	--링크소환 제약
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	--효과 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.cn2)
	e2:SetValue(cm.va2)
	c:RegisterEffect(e2)

	--소환 성공시
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--퍼미션
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.cn4)
	e4:SetCost(cm.co4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end

--효과 내성
function cm.cn2(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function cm.va2(e,re)
	return re:IsActiveType(0x1) and re:GetOwner()~=e:GetOwner()
end

--데미지
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.filter(c)
	return c:GetCounter(0xcbc)>0
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.filter,tp,0x0c,0,1,nil)
	end
	local ct=Duel.GetCounter(0,1,0,0xcbc)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*100)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

--퍼미션
function cm.cn4(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		return false
	end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_MZONE and re:IsActiveType(0x1) and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
	and Duel.IsChainNegatable(ev) and rp==1-tp
end
function cm.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
		and Duel.IsCanRemoveCounter(tp,1,0,0xcbc,3,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RemoveCounter(tp,1,0,0xcbc,3,REASON_COST)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
	end
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		if re:IsActiveType(0x2+0x4) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then ec:CancleToGrave() end
		if Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.Damage(p,800,REASON_EFFECT)
		end
	end
end
