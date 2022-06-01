--아르카나 포스 X-휠 오브 포춘
function c82710005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(c82710005.tar1)	
	e1:SetOperation(c82710005.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TOSS_COIN_NEGATE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c82710005.con4)
	e4:SetOperation(c82710005.op4)
	c:RegisterEffect(e4)
end
c82710005.toss_coin=true
function c82710005.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c82710005.ofil1(c,e,tp)
	return c:IsSetCard(0x5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(82710005)
end
function c82710005.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else
		res=Duel.TossCoin(tp,1)
	end
	c82710005.arcanareg(c,res)
	if res==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c82710005.ofil1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,fale,false,POS_FACEUP_DEFENSE)
		end
	end
end
function c82710005.arcanareg(c,coin)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCondition(c82710005.acon1)
	e1:SetTarget(c82710005.atar1)
	e1:SetTarget(c82710005.aop1)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c82710005.anfil1(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c82710005.acon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(36690018)==0 and Duel.GetCurrentPhase()~=PHASE_DRAW
		and eg:IsExists(c82710005.anfil1,1,nil,1-tp)
end
function c82710005.atar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function c82710005.aop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c82710005.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rp==tp and re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x5) and not c:IsPublic()
end
function c82710005.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not global_arcana_fortune and Duel.SelectYesNo(tp,aux.Stringid(82710005,0)) then
		Duel.Hint(HINT_CARD,0,82710005)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		global_arcana_fortune=true
	end
end