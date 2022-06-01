--KMS 티르피츠
function c81180000.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,2,4,nil,nil,99)
	
	--link meta
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81180000,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetTarget(c81180000.tg1)
	e1:SetOperation(c81180000.op1)
	c:RegisterEffect(e1)

	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81180000,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81180000.cn2)
	e2:SetTarget(c81180000.tg2)
	e2:SetOperation(c81180000.op2)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCondition(c81180000.cn4)
	e4:SetCost(c81180000.co4)
	c:RegisterEffect(e4)
	
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81180000,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c81180000.cn3)
	e3:SetTarget(c81180000.tg3)
	e3:SetOperation(c81180000.op3)
	c:RegisterEffect(e3)
end

--link meta
function c81180000.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then
		return tc and tc:IsControler(1-tp) and tc:IsAbleToRemove(nil,POS_FACEDOWN) and tc:IsType(TYPE_LINK) 
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c81180000.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end

--destroy
function c81180000.cfilter0(c)
	return c:IsFaceup() and c:IsCode(81180180) and c:GetSequence()>=5
end
function c81180000.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81180000.cfilter0,tp,LOCATION_MZONE,0,1,nil)
end
function c81180000.cn4(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c81180000.cfilter0,tp,LOCATION_MZONE,0,1,nil)
end
function c81180000.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,2,REASON_COST)
	end
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c81180000.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c81180000.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end

--spsummon
function c81180000.cn3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ)
	and ( ( rp~=tp and c:IsReason(REASON_EFFECT) ) or c:IsReason(REASON_BATTLE) )
end
function c81180000.filter1(c,e,tp)
	return c:GetLevel()==1 and c:IsSetCard(0xcb5) and c:IsType(TYPE_MONSTER)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
	and Duel.IsExistingTarget(c81180000.filter2,tp,LOCATION_GRAVE,0,1,c,c:GetCode(),e,tp)
end
function c81180000.filter2(c,code,e,tp)
	return not c:IsCode(code)
	and c:GetLevel()==1 and c:IsSetCard(0xcb5) and c:IsType(TYPE_MONSTER)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c81180000.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c81180000.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c81180000.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c81180000.filter2,tp,LOCATION_GRAVE,0,1,1,tc1,tc1:GetCode(),e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function c81180000.op3(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or ft<=0 or ( g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) ) then
		return
	end
	if ft<g:GetCount() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end


