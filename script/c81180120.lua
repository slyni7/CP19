--KMS 론
function c81180120.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c81180120.mat,3,5,nil,nil,99)
	
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	--can't act
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c81180120.cn2)
	e2:SetOperation(c81180120.op2)
	c:RegisterEffect(e2)
	
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81180120,0))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c81180120.cn3)
	e3:SetCost(c81180120.co3)
	e3:SetTarget(c81180120.tg3)
	e3:SetOperation(c81180120.op3)
	c:RegisterEffect(e3)
end

--material
function c81180120.mat(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK)
end

--can't act
function c81180120.cn2(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c81180120.op2(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

--negate
function c81180120.filter1(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xcb5)
end
function c81180120.cn3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(c81180120.filter1,1,nil) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
	and re:IsActiveType(TYPE_MONSTER) and ep~=tp and Duel.IsChainNegatable(ev)	
end
function c81180120.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81180120.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c81180120.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and c:IsRelateToEffect(e) and c:IsType(TYPE_XYZ) and rc:IsRelateToEffect(re) then
		local og=rc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(rc))
	end
end


