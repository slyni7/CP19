--고스토피아 린
function c76859014.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c76859014.xfil1,7,3,c76859014.xfil2,aux.Stringid(76859014,0),3,c76859014.xop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCondition(c76859014.con1)
	e1:SetOperation(c76859014.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCountLimit(1)
	e2:SetCondition(c76859014.con2)
	e2:SetOperation(c76859014.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCondition(c76859014.con3)
	e3:SetTarget(c76859014.tg3)
	e3:SetOperation(c76859014.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetValue(c76859014.val5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetCost(c76859014.cost6)
	e6:SetTarget(c76859014.tg6)
	e6:SetOperation(c76859014.op6)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_REVERSE_DAMAGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(1,0)
	e7:SetValue(c76859014.val7)
	c:RegisterEffect(e7)
end
function c76859014.xfil1(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c76859014.xfil2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsCode(76859014)
end
function c76859014.xofil(c)
	return c:IsSetCard(0x2cc) and c:IsAbleToGraveAsCost()
end
function c76859014.xop(e,tp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859014.xofil,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,c76859014.xofil,1,1,REASON_COST,nil)
	c:RegisterFlagEffect(76859014,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
	return true
end
function c76859014.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c76859014.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(76859014)>0 then
		local ct=c:GetTurnCounter()
		c:SetTurnCounter(ct+1)
	else
		c:RegisterFlagEffect(76859014,RESET_EVENT+0x1fe0000,0,0)
		c:SetTurnCounter(1)
	end
end
function c76859014.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==tp and c:GetFlagEffect(76859014)<1
end
function c76859014.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(76859014,RESET_EVENT+0x1fe0000,0,0)
	c:SetTurnCounter(1)
end
function c76859014.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	return c:GetFlagEffect(76859014)>0 and ct==2 and Duel.GetTurnPlayer()==tp
end
function c76859014.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c76859014.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local g=Duel.GetDecktopGroup(tp,3)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end
function c76859014.val5(e,te)
	return e:GetHandler()~=te:GetOwner() and te:IsActiveType(TYPE_MONSTER)
end
function c76859014.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,nil,1,nil) and c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetFlagEffect(76859014)<1
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	local tc=sg:GetFirst()
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	Duel.Release(tc,REASON_COST)
	if atk>def then
		e:SetLabel(atk)
	else
		e:SetLabel(def)
	end
end
function c76859014.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function c76859014.op6(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,e:GetLabel(),REASON_EFFECT)
end
function c76859014.val7(e,re,r,rp,rc)
	local c=e:GetHandler()
	return bit.band(r,REASON_BATTLE)>0 and c:IsRelateToBattle()
end