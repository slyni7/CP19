--Melodevil Con Fuocco
function c81150040.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c81150040.mat),2,3,c81150040.mat2)
	
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c81150040.val)
	c:RegisterEffect(e1)
	
	--status increase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c81150040.val2)
	c:RegisterEffect(e2)
	
	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81150040,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,81150040)
	e3:SetCondition(c81150040.vcn)
	e3:SetTarget(c81150040.vtg)
	e3:SetOperation(c81150040.vop)
	c:RegisterEffect(e3)
end

--material
function c81150040.mat(c,lc,sumtype,tp)
	return c:IsType(TYPE_EFFECT,lc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_WIND,lc,sumtype,tp)
end
function c81150040.mat2(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xcb2)
end

--immune
function c81150040.val(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:IsActivated() and te:GetOwner():IsLevelBelow(5)
end

--status
function c81150040.valfilter(c)
	return c:IsSetCard(0xcb2) and c:IsFaceup()
end
function c81150040.val2(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c81150040.valfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)*100
end


--salvage
function c81150040.vcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c81150040.filter2(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb2) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81150040.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81150040.filter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c81150040.vop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81150040.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
