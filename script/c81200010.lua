--HMS(로열 네이비) 재블린
function c81200010.initial_effect(c)

	--proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81200010)
	e1:SetCondition(c81200010.cn1)
	c:RegisterEffect(e1)
	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81200010,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,81200011)
	e2:SetCondition(c81200010.cn2)
	e2:SetTarget(c81200010.tg2)
	e2:SetOperation(c81200010.op2)
	c:RegisterEffect(e2)
end

--proc
function c81200010.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xcb7) and c:IsType(TYPE_TUNER)
end
function c81200010.cn1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and ( Duel.IsExistingMatchingCard(c81200010.filter1,tp,LOCATION_MZONE,0,1,nil)
	or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 )
end

--search
function c81200010.cn2(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return rc:IsSetCard(0xcb7) and r&REASON_SYNCHRO+REASON_LINK~=0
end
function c81200010.filter2(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb8)
end
function c81200010.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81200010.filter2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81200010.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81200010.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


