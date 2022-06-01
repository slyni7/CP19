--수학의 여신 세미
function c18452921.initial_effect(c)
	c:SetSPSummonOnce(m)
	aux.AddEquationProcedure(c,nil,0,1,-1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c18452921.con1)
	e1:SetOperation(c18452921.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c18452921.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetTarget(c18452921.tar3)
	e3:SetOperation(c18452921.op3)
	c:RegisterEffect(e3)
end
c18452921.custom_type=CUSTOMTYPE_EQUATION
function c18452921.nfil1(c)
	if not c:IsCustomType(CUSTOMTYPE_EQUATION) then
		return false
	end
	local t=c.equation_formula
	local eqfun=t[1]
	local eqval=eqfun()
	return eqval>0 and c:IsAbleToGraveAsCost()
end
function c18452921.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c18452921.nfil1,tp,LOCATION_DECK,0,1,nil)
end
function c18452921.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18452921.nfil1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=g:GetFirst()
	local t=tc.equation_formula
	local eqfun=t[1]
	local eqval=eqfun()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(eqval)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c18452921.val2(e,c)
	return c:GetLevel()*300
end
function c18452921.tfil3(c,lv)
	if not c:IsCustomType(CUSTOMTYPE_EQUATION) then
		return false
	end
	local t=c.equation_formula
	local eqfun=t[1]
	local eqval=eqfun()
	return eqval==lv and c:IsAbleToHand()
end
function c18452921.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18452921.tfil3,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18452921.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18452921.tfil3,tp,LOCATION_DECK,0,1,1,nil,c:GetLevel())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end