--뱀피어스 루나스테이지
--카드군 번호: 0xc98
function c81259060.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81259060+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c81259060.op1)
	c:RegisterEffect(e1)
	
	--배틀 개시시
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81259060.cn2)
	e2:SetTarget(c81259060.tg2)
	e2:SetOperation(c81259060.op2)
	c:RegisterEffect(e2)
	
	--보호
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c81259060.tg3)
	e3:SetValue(c81259060.val3)
	e3:SetOperation(c81259060.op3)
	c:RegisterEffect(e3)
end

--발동
function c81259060.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc98) and not c:IsCode(81259060)
end
function c81259060.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then
		return
	end
	local g=Duel.GetMatchingGroup(c81259060.tfil0,tp,0x01,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(81259060,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

--배틀 개시시
function c81259060.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c81259060.tfil1(c)
	return not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function c81259060.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81259060.tfil1,tp,0,LOCATION_MZONE,1,nil)
	end
end
function c81259060.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81259060.tfil1,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE,true)
end

--보호
function c81259060.rpfil0(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xc98) and c:IsControler(tp)
	and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
	and not c:IsReason(REASON_REPLACE)
end
function c81259060.val3(e,c)
	return c81259060.rpfil0(c,e:GetHandlerPlayer())
end
function c81259060.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return eg:IsExists(c81259060.rpfil0,1,nil,tp)
		and	Duel.CheckLPCost(tp,500)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(81259060,0)) then
		return true
	else
		return false
	end
end
function c81259060.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
