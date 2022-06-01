--Guilty Whirlwind
function c81110020.initial_effect(c)

	--recovery
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(81110020,0))
	e0:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e0:SetCode(EVENT_LEAVE_FIELD)
	e0:SetCountLimit(1,81110020)
	e0:SetCondition(c81110020.cn)
	e0:SetTarget(c81110020.tg)
	e0:SetOperation(c81110020.op)
	c:RegisterEffect(e0)
	--turn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81110020.tcn3)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81110020.tcn5)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c81110020.tcn7)
	e3:SetTargetRange(0,0xff)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c81110020.tcn7)
	e4:SetValue(c81110020.val)
	c:RegisterEffect(e4)
end

--turn count
function c81110020.tcn3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>=3
end
function c81110020.tcn5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>=5
end
function c81110020.tcn7(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>=7
end
function c81110020.val(e,c)
	return e:GetHandler():GetDefense()
end

--recovery
function c81110020.cn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end

function c81110020.filter(c)
	return c:IsAbleToHand() and c:IsLevelBelow(6) and c:IsSetCard(0xcae)
end
function c81110020.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81110020.filter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81110020.op(e,tp,ep,eg,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81110020.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
