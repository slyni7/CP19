--넥서스 아카시아
function c76859305.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2c5),nil,1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetCost(c76859305.cost1)
	e1:SetTarget(c76859305.tg1)
	e1:SetOperation(c76859305.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetCost(c76859305.cost1)
	e2:SetTarget(c76859305.tg1)
	e2:SetOperation(c76859305.op1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c76859305.con3)
	e3:SetCost(c76859305.cost3)
	e3:SetTarget(c76859305.tg3)
	e3:SetOperation(c76859305.op3)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCost(c76859305.cost5)
	c:RegisterEffect(e5)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCondition(c76859305.con4)
	e4:SetCost(c76859305.cost4)
	e4:SetTarget(c76859305.tg4)
	e4:SetOperation(c76859305.op4)
	c:RegisterEffect(e4)
end
function c76859305.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(76859405)<1
	end
	c:RegisterFlagEffect(76859405,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
end
function c76859305.tfilter1(c)
	return c:IsSetCard(0x2c5) and c:IsAbleToGrave()
end
function c76859305.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859305.tfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
			and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c76859305.op1(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	local ct1=dg:GetCount()
	if ct1<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c76859305.tfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,ct1,nil)
	if g:GetCount()>0 then
		local ct2=Duel.SendtoGrave(g,REASON_EFFECT)
		if ct2>0 then
			local tg=dg:Select(tp,ct2,ct2,nil)
			local ct3=Duel.Destroy(tg,REASON_EFFECT)
			if ct3>0 then
				local c=e:GetHandler()
				if c:IsRelateToEffect(e) then
					c:RegisterFlagEffect(76859305,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
				end
				Duel.Recover(tp,ct3*400,REASON_EFFECT)
			end
		end
	end
end
function c76859305.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(76859305)>0
end
function c76859305.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
			and (Duel.GetFlagEffect(tp,76859305)+Duel.GetFlagEffect(tp,76859355)==0
				and not Duel.IsPlayerAffectedByEffect(tp,76859317))
	end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.RegisterFlagEffect(tp,76859305,RESET_PHASE+PHASE_END,0,1)
end
function c76859305.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
			and Duel.IsPlayerAffectedByEffect(tp,76859317)
	end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.RegisterFlagEffect(tp,76859305,RESET_PHASE+PHASE_END,0,1)
end
function c76859305.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_TRAP)
			and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1
	end
end
function c76859305.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_TRAP)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
function c76859305.con4(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c76859305.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
			and ((Duel.GetFlagEffect(tp,76859305)==0 or Duel.IsPlayerAffectedByEffect(tp,76859317))
				and Duel.GetFlagEffect(tp,76859355)==0)
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,76859355,RESET_PHASE+PHASE_END,0,1)
end
function c76859305.tfilter41(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x2c5) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76859305.tfilter42(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_TRAP) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSSetable()
end
function c76859305.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c76859305.tfilter41,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c76859305.tfilter42,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c76859305.tfilter41,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g2=Duel.SelectTarget(tp,c76859305.tfilter42,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c76859305.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
		return
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<2 then
		return
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then
		return
	end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if tc1==e:GetLabelObject() then
		Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SSet(tp,tc2)
	else
		Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SSet(tp,tc1)
	end
end