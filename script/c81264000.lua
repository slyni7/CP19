--베노퀄리아 바이피고
--카드군 번호: 0xc94

function c81264000.initial_effect(c)

	--의식 레벨
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(c81264000.val)
	c:RegisterEffect(e1)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81264000,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,81264000)
	e2:SetTarget(c81264000.tg2)
	e2:SetOperation(c81264000.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

--의식 레벨
function c81264000.val(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0xc94) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end

-- 서치
function c81264000.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
	and ( c:IsSetCard(0xc94) or c:IsType(TYPE_SPELL) )
end
function c81264000.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81264000.filter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81264000.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=1
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2 then tc=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81264000.filter,tp,LOCATION_DECK,0,1,tc,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
