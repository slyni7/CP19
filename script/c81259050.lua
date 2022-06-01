--뱀피어스로네 루나게라
--카드군 번호: 0xc98
function c81259050.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,"L",nil,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),aux.FilterBoolFunction(Card.IsSetCard,0xc98),aux.FilterBoolFunction(Card.IsType,0x1))

	--유발
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c81259050.cn1)
	e1:SetTarget(c81259050.tg1)
	e1:SetOperation(c81259050.op1)
	c:RegisterEffect(e1)
	
	--샐비지
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,81259050)
	e2:SetCondition(c81259050.cn2)
	e2:SetTarget(c81259050.tg2)
	e2:SetOperation(c81259050.op2)
	c:RegisterEffect(e2)
	
	--내성 부여
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c81259050.cn3)
	e3:SetTargetRange(LOCATION_FZONE,0)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end

--유발
function c81259050.cfil0(c,tp)
	return c:IsPreviousLocation(0x10) and c:GetPreviousControler()==tp and c:IsSetCard(0xc98) and c:IsFaceup()
end	
function c81259050.cn1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81259050.cfil0,1,e:GetHandler(),tp)
end
function c81259050.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0x0c,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x0c)
end
function c81259050.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,0x0c,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--샐비지
function c81259050.cn2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(0x10) and r==REASON_SYNCHRO
end
function c81259050.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc98) and ( c:IsLocation(0x10) or c:IsFaceup() )
end
function c81259050.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81259050.tfil0,tp,0x10+0x20,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10+0x20)
end
function c81259050.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81259050.tfil0,tp,0x10+0x20,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--내성 부여
function c81259050.cn3(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and ( ph==PHASE_MAIN1 or ph==PHASE_MAIN2 )
end
