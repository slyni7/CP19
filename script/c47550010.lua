--네파시아 집행자
function c47550010.initial_effect(c)

	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e99:SetCode(EVENT_SPSUMMON_SUCCESS)
	e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e99:SetCondition(c47550010.con1)
	e99:SetOperation(c47550010.op1)
	c:RegisterEffect(e99)

	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c47550010.lcheck)
	c:EnableReviveLimit()

	--attribute dark
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetCondition(c47550010.eqcon)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)

	--light:indestructionbybattle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c47550010.ndcon)
	e1:SetTarget(c47550010.ndtar)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)


	--dark:negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1)
	e4:SetCondition(c47550010.negcon)
	e4:SetCost(c47550010.negcost)
	e4:SetTarget(c47550010.negtg)
	e4:SetOperation(c47550010.negop)
	c:RegisterEffect(e4)
end

function c47550010.eqcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<3
end

function c47550010.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x487)
end

function c47550010.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c47550010.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c47550010.tar11)
	Duel.RegisterEffect(e1,tp)
end
function c47550010.tar11(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(47550010) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end


function c47550010.ndcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47550010.ndtar(e,c)
	return (c:IsLinkState() and c:IsSetCard(0x487)) or c==e:GetHandler()
end



function c47550010.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev) and e:GetHandler():IsAttribute(ATTRIBUTE_DARK)
end
function c47550010.cfilter(c,g)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and g:IsContains(c) and c:IsSetCard(0x487)
end
function c47550010.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c47550010.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c47550010.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c47550010.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c47550010.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end