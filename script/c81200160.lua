--HMS(로열 네이비) 유니콘은 살아있어!
--카드군 번호: 0xcb7
function c81200160.initial_effect(c)

	c:SetSPSummonOnce(81200160)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c81200160.mat,1,1)
	
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c81200160.cn3)
	e1:SetTarget(c81200160.tg3)
	e1:SetOperation(c81200160.op3)
	c:RegisterEffect(e1)
end

--소재
function c81200160.mat(c)
	return c:IsLinkSetCard(0xcb7) and not c:IsLinkType(TYPE_LINK)
end

--서치
function c81200160.cn3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c81200160.filter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb8)
end
function c81200160.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81200160.filter0,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c81200160.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81200160.filter0,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


