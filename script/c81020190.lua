--초목 식육덩굴
function c81020190.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,false,aux.FilterBoolFunction(c81020190.mat1),aux.FilterBoolFunction(c81020190.mat2))
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	
	--can't be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c81020190.va1)
	c:RegisterEffect(e1)
	
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81020190,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c81020190.cn2)
	e2:SetTarget(c81020190.tg2)
	e2:SetOperation(c81020190.op2)
	c:RegisterEffect(e2)
	
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81020190,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c81020190.co3)
	e3:SetTarget(c81020190.tg3)
	e3:SetOperation(c81020190.op3)
	c:RegisterEffect(e3)
end

--material
function c81020190.mat1(c)
	return c:IsSetCard(0xca2) and c:IsType(TYPE_FUSION)
end
function c81020190.mat2(c)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()<1 and c:IsType(TYPE_EFFECT)
end

--can't be target
function c81020190.va1(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end

--salvage
function c81020190.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c81020190.filter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and c:IsSetCard(0xca2) and c:IsFaceup()
end
function c81020190.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81020190.filter1,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c81020190.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81020190.filter1,tp,LOCATION_REMOVED,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local cg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if cg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81020190,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local sg=cg:Select(tp,1,1,nil)
			Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
		end
	end
end

--destroy
function c81020190.filter3(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SPELL) and c:IsSetCard(0xca2)
end
function c81020190.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_GRAVE
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81020190.filter3,tp,loc,0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81020190.filter3,tp,loc,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81020190.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,0,0,0)
end
function c81020190.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,2,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end


