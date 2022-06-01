--아르카나 포스 XVI-더 타워
function c82710010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_COIN+CATEGORY_SEARCH)
	e1:SetTarget(c82710010.tar1)	
	e1:SetOperation(c82710010.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(82710010,2))
	e4:SetCountLimit(1,82710010)
	e4:SetCost(c82710010.cost4)
	e4:SetTarget(c82710010.tar4)
	e4:SetOperation(c82710010.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetCountLimit(1,82710011)
	e5:SetTarget(c82710010.tar5)
	e5:SetOperation(c82710010.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_HAND)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetDescription(aux.Stringid(82710010,3))
	e6:SetCountLimit(1,82710012)
	e6:SetCost(c82710010.cost6)
	e6:SetTarget(c82710010.tar6)
	e6:SetOperation(c82710010.op6)
	c:RegisterEffect(e6)
end
c82710010.toss_coin=true
function c82710010.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c82710010.ofil1(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	return ((te and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or c:IsAbleToHand()) and c:IsCode(82710018)
end
function c82710010.op1(e,tp,eg,ep,ev,re,r,rp)
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
	c82710010.arcanareg(c,res)
	if res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local tg=Duel.SelectMatchingCard(tp,c82710010.ofil1,tp,LOCATION_DECK,0,1,1,nil,tp)
		local tc=tg:GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:CheckActivateEffect(false,false,false) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or Duel.SelectOption(tp,aux.Stringid(82710010,0),aux.Stringid(82710010,1))==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				local tpe=tc:GetType()
				local te=tc:GetActivateEffect()
				local co=te:GetCost()
				local tg=te:GetTarget()
				local op=te:GetOperation()
				e:SetCategory(te:GetCategory())
				e:SetProperty(te:GetProperty())
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				Duel.HintActivation(te)
				e:SetActiveEffect(te)
				Duel.Hint(HINT_CARD,0,tc:GetCode())
				if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)<1 then
					tc:CancelToGrave(false)
				end
				tc:CreateEffectRelation(te)
				if co then
					co(te,tp,eg,ep,ev,re,r,rp,1)
				end
				if tg then
					tg(te,tp,eg,ep,ev,re,r,rp,1)
				end
				Duel.BreakEffect()
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				local etc=nil
				if g then
					etc=g:GetFirst()
					while etc do
						etc:CreateEffectRelation(te)
						etc=g:GetNext()
					end
				end
				if op then
					op(te,tp,eg,ep,ev,re,r,rp)
				end
				tc:ReleaseEffectRelation(te)
				if g then
					etc=g:GetFirst()
						while etc do
						etc:ReleaseEffectRelation(te)
						etc=g:GetNext()
					end
				end
				e:SetActiveEffect(nil)
				e:SetCategory(CATEGORY_COIN+CATEGORY_SEARCH)
				e:SetProperty(0)
				Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
			end
		end
	end
end
function c82710010.arcanareg(c,coin)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCountLimit(1)
	e1:SetCondition(c82710010.acon1)
	e1:SetTarget(c82710010.atar1)
	e1:SetOperation(c82710010.op1)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c82710010.acon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(36690018)==0 and Duel.GetTurnPlayer()~=tp
end
function c82710010.atar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	Duel.SetOperationInf(0,CATEGORY_TOHAND,c,1,0,0)
end
function c82710010.aop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c82710010.cfil4(c)
	return c:IsSetCard(0x5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c82710010.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c82710010.cfil4,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c82710010.cfil4,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c82710010.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c82710010.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c82710010.tfil5(c)
	return aux.IsArcanaCard(c) and c:IsAbleToHand()
end
function c82710010.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c82710010.tfil5,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c82710010.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG,ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82710010.tfil5,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c82710010.cfil6(c)
	return c:IsSetCard(0x5) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c82710010.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable() and Duel.IsExistingMatchingCard(c82710010.cfil6,tp,LOCATION_HAND,0,1,c)
	end
	Duel.Hint(HINT_SELECTSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c82710010.cfil6,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c82710010.tar6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c82710010.op6(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end