--H. Enchanter: 2
function c99970022.initial_effect(c)

	--직접 공격
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(c99970022.dircon)
	c:RegisterEffect(e3)
	
	--드로우
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970022,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,99970022)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c99970022.target)
	e1:SetOperation(c99970022.activate)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c99970022.spcon)
	e2:SetTarget(c99970022.sptg)
	e2:SetCountLimit(1,99970022)
	e2:SetOperation(c99970022.spop)
	c:RegisterEffect(e2)
	
end

--직접 공격
function c99970022.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd33)
end
function c99970022.dircon(e)
	return Duel.IsExistingMatchingCard(c99970022.cfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,1,nil)
end

--드로우
function c99970022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd32)
end
function c99970022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c99970022.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c99970022.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c99970022.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99970022.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()~=1 then return end
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end

--특수 소환
function c99970022.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c99970022.spfilter(c,e,tp)
	return c:IsSetCard(0xd32) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99970022.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99970022.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99970022.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

