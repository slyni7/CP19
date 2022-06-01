--MNF(비시아 성좌) 장 바르
function c81210010.initial_effect(c)

	aux.EnablePendulumAttribute(c)
	
	--search(P)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81210010,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,81210010)
	e2:SetTarget(c81210010.tg2)
	e2:SetOperation(c81210010.op2)
	c:RegisterEffect(e2)
	
	--atk twice
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	
	--atk increase
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetOperation(c81210010.op4)
	c:RegisterEffect(e4)
	
	--plimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetRange(LOCATION_PZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c81210010.plimit)
	c:RegisterEffect(e5)
end

--plimit
function c81210010.plimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_MACHINE)
	and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

--search(P)
function c81210010.filter1(c)
	return c:IsAbleToHand() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function c81210010.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c81210010.filter1,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c81210010.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GetMatchingGroup(c81210010.filter1,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if tg1:GetCount()==2 then
		Duel.ConfirmCards(1-tp,tg1)
		Duel.ShuffleDeck(tp)
		local cg=tg1:Select(1-tp,1,1,nil)
		local tc=cg:GetFirst()
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		tg1:RemoveCard(tc)
		Duel.SendtoExtraP(tg1,nil,REASON_EFFECT)
	end
end

--atk increase
function c81210010.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(600)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end


