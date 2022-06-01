--역신 무녀의 휴식
--카드군 번호: 0xcbc
function c81230030.initial_effect(c)

	--카운터
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81230030,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81230030.tg1)
	e1:SetOperation(c81230030.op1)
	c:RegisterEffect(e1)
	
	--공통 효과
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81230030,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetTarget(c81230030.tg2)
	e2:SetOperation(c81230030.op2)
	c:RegisterEffect(e2)
end

--카운터
function c81230030.filter0(c)
	return c:IsFaceup() and c:IsSetCard(0xcbc) and c:IsCanAddCounter(0xcbc,3)
end
function c81230030.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(tp) and c81230030.filter0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81230030.filter0,tp,LOCATION_ONFIELD,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,94)
	Duel.SelectTarget(tp,c81230030.filter0,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0xcbc)
end
function c81230030.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0xcbc,3)
		if Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetCounter(e:GetHandlerPlayer(),1,0,0xcbc)>=3 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

--공통 효과
function c81230030.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xcbc) and c:IsCanAddCounter(0xcbc,1)
end
function c81230030.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(tp) and c81230030.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81230030.filter1,tp,LOCATION_ONFIELD,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,94)
	Duel.SelectTarget(tp,c81230030.filter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xcbc)
end
function c81230030.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0xcbc,1)
	end
end


