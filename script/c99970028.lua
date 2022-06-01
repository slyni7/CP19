--L. Enchanter: 8
function c99970028.initial_effect(c)

	--엑시즈 소환
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd32),4,2,c99970028.ovfilter,aux.Stringid(99970028,0),2,c99970028.xyzop)
	c:EnableReviveLimit()
	
	--공수 감소
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c99970028.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)

	--샐비지 + 파괴
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970028,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c99970028.cost)
	e1:SetTarget(c99970028.target)
	e1:SetOperation(c99970028.activate)
	c:RegisterEffect(e1,false,1)
	
end

--엑시즈 소환
function c99970028.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd32) and not c:IsCode(99970028) and c:IsAttribute(ATTRIBUTE_WIND+ATTRIBUTE_DARK)
end
function c99970028.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,99970028)==0 end
	Duel.RegisterFlagEffect(tp,99970028,RESET_PHASE+PHASE_END,0,1)
	return true
end

--공수 감소
function c99970028.val(e,tp)
	return Duel.GetOverlayCount(tp,1,1)*-200
end

--샐비지
function c99970028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c99970028.filter(c)
	return c:IsSetCard(0xd32) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99970028.dfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c99970028.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and c99970028.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99970028.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c99970028.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	local tc=g:GetFirst()
	local dg=Duel.GetMatchingGroup(c99970028.dfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	if dg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	end
end
function c99970028.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c99970028.dfilter,tp,0,LOCATION_MZONE,1,1,nil,tc:GetAttack())
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
