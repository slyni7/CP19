--파이널 익스플로전
function c17290016.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,17290016+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17290016.tar1)
	e1:SetOperation(c17290016.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17290016,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetCondition(c17290016.con2)
	e2:SetTarget(c17290016.tg2)
	e2:SetOperation(c17290016.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMONABLE_CARD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(c17290016.tg2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_LIMIT_SET_PROC)
	e4:SetCondition(c17290016.con4)
	e4:SetTarget(c17290016.tg2)
	c:RegisterEffect(e4)
end
function c17290016.filter(c)
	return c:IsRitualMonster() and c:IsSetCard(0x2c3) and c:IsSetCard(0x8) and c:IsAbleToHand()
end
function c17290016.filter2(c)
	return c:IsRitualSpell() and c:IsAbleToHand() and c:IsFaceup() and c:IsSetCard(0x2c3) and not c:IsCode(17290016)
end
function c17290016.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c17290016.filter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c17290016.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17290016.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c17290016.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(17290016,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c17290016.con4(e,c)
	if not c then
		return true
	end
	return false
end
function c17290016.tfunction1(c,rc)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	else
		return c:GetRitualLevel(rc)
	end
end
function c17290016.con2(e,c)
	if c==nil then
		return e:GetHandler():IsAbleToRemove()
	end
	local tp=c:GetControler()
	local m=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and m:CheckWithSumGreater(c17290016.tfunction1,c:GetLevel(),c)
end
function c17290016.tg2(e,c)
	if type(c)=="Card" then
		return c:IsSetCard(0x2c3)
	else
		return true
	end
end
function c17290016.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local m=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mat=m:SelectWithSumGreater(tp,c17290016.tfunction1,c:GetLevel(),c)
	mat:AddCard(e:GetHandler())
	c:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_COST+REASON_RITUAL+REASON_MATERIAL+REASON_SUMMON)
end