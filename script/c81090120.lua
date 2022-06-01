function c81090120.initial_effect(c)

	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcac),4,2,c81090120.sum,aux.Stringid(81090120,0),63,c81090120.sumop)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetValue(0x10)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTURCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81090120.con)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c81090120.val)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c81090120.cost)
	e4:SetTarget(c81090120.target)
	e4:SetOperation(c81090120.operation)
	c:RegisterEffect(e4)

end

--summon method
function c81090120.sum(c,tp,xyzc)
	return c:IsFaceup() and c:IsSetCard(0xcac) and c:IsType(TYPE_XYZ,xyzc,SUMMON_TYPE_XYZ,tp)
	and not c:IsCode(81090120)
	and c:GetOverlayCount()==0
end

function c81090120.sumop(e,tp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,81090120)==0
	end
	Duel.RegisterFlagEffect(tp,81090120,RESET_PHASE+PHASE_END,0,1)
	return true
end

--indes
function c81090120.con(e)
	return e:GetHandler():GetOverlayCount()~=0
end

--attack increase
function c81090120.val(e,c)
	return Duel.GetOverlayCount(c:GetControler(),1,1)*800
end

--position
function c81090120.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c81090120.tgfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c81090120.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and c81090120.tgfilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81090120.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HNITMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c81090120.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end

function c81090120.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
