--펑크랙 인젝터
--카드군 번호: 0xcbf
function c81260060.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcbf),1,1,c81260060.mat)
	
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81260060,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81260060)
	e1:SetTarget(c81260060.tg1)
	e1:SetOperation(c81260060.op1)
	c:RegisterEffect(e1)
	
	--특수소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81260060,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81260061)
	e2:SetCondition(c81260060.cn2)
	e2:SetTarget(c81260060.tg2)
	e2:SetOperation(c81260060.op2)
	c:RegisterEffect(e2)
end

--소재
function c81260060.mat(g,lc)
	return not g:IsExists(Card.IsType,1,nil,TYPE_LINK)
end

--서치
function c81260060.filter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcbf) and c:IsType(TYPE_MONSTER)
end
function c81260060.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81260060.filter0,tp,0x01+0x10,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01+0x10)
end
function c81260060.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81260060.filter0,tp,0x01+0x10,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--특수소환
function c81260060.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
	and c:IsPreviousSetCard(0xcbf)
	and c:IsReason(REASON_BATTLE+REASON_EFFECT)
	and c:IsControler(tp)
end
function c81260060.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81260060.cfilter,1,nil,tp)
end
function c81260060.filter1(c,e,tp)
	return c:IsSetCard(0xcbf) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81260060.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81260060.filter1,tp,0x01+0x10,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01+0x10)
end
function c81260060.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81260060.filter1,tp,0x01+0x10,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


