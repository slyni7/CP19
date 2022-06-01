--FFNF(아이리스 리브레) 생 루이
function c81210000.initial_effect(c)

	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)

	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c81210000.plimit)
	c:RegisterEffect(e2)
	
	--search(P)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81210000,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,81210000)
	e3:SetCondition(c81210000.cn3)
	e3:SetTarget(c81210000.tg3)
	e3:SetOperation(c81210000.op3)
	c:RegisterEffect(e3)
	
	--공격력 참조
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c81210000.cn4)
	e4:SetTarget(c81210000.tg4)
	e4:SetOperation(c81210000.op4)
	c:RegisterEffect(e4)

	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	
	--견제
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(81210000,2))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,81210001)
	e6:SetCost(c81210000.co6)
	e6:SetTarget(c81210000.tg6)
	e6:SetOperation(c81210000.op6)
	c:RegisterEffect(e6)
end

--plimit
function c81210000.plimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_MACHINE)
	and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

--search(P)
function c81210000.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
	and bit.band(c:GetPreviousTypeOnField(),TYPE_PENDULUM)~=0
	and c:IsPreviousLocation(LOCATION_ONFIELD)
	and c:GetPreviousControler()==tp
end
function c81210000.cn3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81210000.cfilter,1,nil,tp)
end
function c81210000.filter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb9) and c:IsType(0x2+0x4)
end
function c81210000.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81210000.filter1,tp,LOCATION_DECK+0x10,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function c81210000.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81210000.filter1),tp,LOCATION_DECK+0x10,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		if c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
	
--equipment
function c81210000.cn4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL) or c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c81210000.filter2(c)
	return c:IsType(TYPE_PENDULUM) and c:GetLevel()>0
end
function c81210000.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		return Duel.IsExistingTarget(c81210000.filter2,tp,LOCATION_GRAVE,0,1,nil)
	end
end
function c81210000.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then 
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c81210000.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(0x04)
		e1:SetValue(lv*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end

--프리체인
function c81210000.cost(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost() and ( c:IsLocation(0x02) or c:IsFaceup() )
end
function c81210000.co6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81210000.cost,tp,0x02+0x40,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81210000.cost,tp,0x02+0x40,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81210000.tg6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81210000.op6(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end


