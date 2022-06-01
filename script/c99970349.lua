--Orcatia Titania
local m=99970349
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT))
	
	--효과 제한
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(cm.disop)
	e1:SetCondition(cm.discon)
	c:RegisterEffect(e1)
	
	--공격 제한
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(cm.atktg)
	e2:SetCondition(cm.atkcon)
	c:RegisterEffect(e2)

	--자가 회수
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(spinel.delay)
	e3:SetCode(EVENT_BE_MATERIAL)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	
end

--효과 제한
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_EARTH+ATTRIBUTE_LIGHT)
		and re:IsActiveType(TYPE_MONSTER) and rp==1-tp
		and re:GetHandler():IsAttribute(ec:GetAttribute())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

--공격 제한
function cm.atkcon(e)
	local ec=e:GetHandler():GetEquipTarget()
	return ec:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WIND+ATTRIBUTE_DARK)
end
function cm.atktg(e,c)
	local ec=e:GetHandler():GetEquipTarget()
	return c:IsAttribute(ec:GetAttribute())
end

--자가 회수
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_MODULE
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(cm.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(m)
end

