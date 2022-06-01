--Guilty - Un-dead Smoke
function c81110050.initial_effect(c)

	aux.AddLinkProcedure(c,nil,2,3,c81110050.mat1)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c81110050.val)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81110050.cn)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c81110050.val2)
	c:RegisterEffect(e3)
	--effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81110050,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,81110050)
	e4:SetCondition(c81110050.ecn)
	e4:SetCost(c81110050.eco)
	e4:SetTarget(c81110050.etg)
	e4:SetOperation(c81110050.eop)
	c:RegisterEffect(e4)
end

--material
function c81110050.mat1(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xcae)
end

--atk
function c81110050.filter2(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER)
end
function c81110050.val(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c81110050.filter2,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)*100
end

--indes
function c81110050.cn(e)
	return e:GetHandler():GetLinkedGroupCount()>0
end
function c81110050.val2(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end

--destroy
function c81110050.filter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return ec:GetLinkedGroup():IsContains(c)
	else
		return bit.band(ec:GetLinkedGroup(c:GetPreviousControler()),bit.lshift(0x1,c:GetPreviousSequence()) )~=0
	end
end
function c81110050.ecn(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81110050.filter,1,nil,e:GetHandler())
end
function c81110050.eco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c81110050.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c81110050.eop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

