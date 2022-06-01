--IJN 카가
function c81190050.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunction(c81190050.mat1),aux.FilterBoolFunction(Card.IsAttackBelow,2000))
	
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81190050,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81190050)
	e1:SetTarget(c81190050.tg1)
	e1:SetOperation(c81190050.op1)
	c:RegisterEffect(e1)
	
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81190050,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81190050.cn2)
	e2:SetCost(c81190050.co2)
	e2:SetTarget(c81190050.tg2)
	e2:SetOperation(c81190050.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_COST)
	e3:SetCondition(c81190050.cn3)
	e3:SetOperation(c81190050.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c81190050.va4)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)
end

--material
function c81190050.mat1(c)
	return c:IsSetCard(0xcb6) and c:IsType(TYPE_MONSTER)
end

--summon
function c81190050.filter1(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0xcb6) and c:IsType(TYPE_SPIRIT)
end
function c81190050.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81190050.filter1,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c81190050.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c81190050.filter1,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end

--matchk
function c81190050.cfilter1(c)
	return c:IsType(TYPE_SPIRIT) and c:IsSetCard(0xcb6)
end
function c81190050.va4(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterial():FilterCount(c81190050.cfilter1,nil))
end

--negate
function c81190050.cn2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
	and ep~=tp
	and re:IsActiveType(TYPE_SPELL)
	and Duel.IsChainNegatable(ev)
	and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c81190050.filter3(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SPIRIT)
end
function c81190050.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81190050.filter3,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81190050.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FAECUP,REASON_COST)
end
function c81190050.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return re:GetHandler():IsAbleToRemove()
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c81190050.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FAECUP,REASON_EFFECT)
	end
end

--atk inc
function c81190050.cn3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c81190050.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(ct*300)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
	end
end


