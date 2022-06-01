--FFNF(아이리스 리브레) 샹파뉴
--카드군 번호: 0xcb9
local m=81210170
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)

	--펜듈럼 제약
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.plimit)
	c:RegisterEffect(e2)
	
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(0x200)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--파괴 대체
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(0x02+0x04)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	e4:SetValue(cm.va4)
	c:RegisterEffect(e4)
	
	--전투 관련
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_PIERCE)
	e5:SetCondition(cm.cn5)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e6:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetRange(0x04)
	e7:SetTargetRange(0,1)
	e7:SetCondition(cm.cn7)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end

--펜듈럼 제약
function cm.plimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_MACHINE) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

--리쿠르트
function cm.nfil0(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and bit.band(c:GetPreviousTypeOnField(),TYPE_PENDULUM)~=0
	and c:IsPreviousLocation(0x0c) and c:GetPreviousControler()==tp
end
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil0,1,nil,tp)
end
function cm.tfil0(c)
	return not c:IsForbidden() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xcb9)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsAbleToHand()
		and Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01+0x02,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01+0x02,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,0x200,POS_FACEUP,true)
		end
	end
end

--파괴 대체
function cm.tfil1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xcb9) and c:IsType(TYPE_PENDULUM) and c:IsLocation(0x04)
	and c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDestructable() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(cm.tfil1,1,nil,tp)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.va4(e,c)
	return cm.tfil1(c,e:GetHandlerPlayer())
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

--전투 관련
function cm.cn5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) or c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.cn7(e,tp,eg,ep,ev,re,r,rp)
	return cm.cn5(e,tp,eg,ep,ev,re,r,rp) and Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
