--파라바이오트 리퍼
function c95481211.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCondition(c95481211.hspcon)
	e0:SetOperation(c95481211.hspop)
	c:RegisterEffect(e0)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10813327,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c95481211.tdcon)
	e1:SetTarget(c95481211.tdtg)
	e1:SetOperation(c95481211.tdop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9156135,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetTarget(c95481211.tdtg)
	e3:SetOperation(c95481211.tdop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98700941,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetCondition(c95481211.spcon)
	e4:SetTarget(c95481211.sptg)
	e4:SetOperation(c95481211.spop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(18940556,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetCondition(c95481211.descon)
	e5:SetTarget(c95481211.destg)
	e5:SetOperation(c95481211.desop)
	c:RegisterEffect(e5)
end
function c95481211.hspfilter(c,ft,tp)
	return c:IsSetCard(0xd47)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c95481211.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c95481211.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c95481211.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c95481211.rmfilter(c)
	return c:IsAbleToRemove() and not c:IsType(TYPE_TOKEN)
end
function c95481211.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c95481211.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(c,1-tp,2,REASON_EFFECT)
	if not c:IsLocation(LOCATION_DECK) then return end
	Duel.ShuffleDeck(1-tp)
end
function c95481211.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetControler()~=c:GetOwner()
end
function c95481211.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95481211.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)~=0 then
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(math.ceil(Duel.GetLP(tp)))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
	end
end
function c95481211.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c95481211.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,5)
		and Duel.GetDecktopGroup(1-tp,5):FilterCount(Card.IsAbleToHand,nil)>0 end
end
function c95481211.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd47) and c:IsAbleToHand()
end
function c95481211.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(1-tp,5) then
		Duel.ConfirmDecktop(1-tp,5)
		local g=Duel.GetDecktopGroup(1-tp,5)
		if g:GetCount()>0 then
			local sg=g:Filter(c95481211.filter,nil)
			if sg:GetCount()>0 then
				if sg:GetFirst():IsAbleToHand() then
				Duel.DisableShuffleCheck()
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(tp,sg)
				Duel.ShuffleHand(1-tp)
				g:Sub(sg)
				Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			else
				Duel.ShuffleDeck(1-tp)
				end
			end
		end
	end
end
