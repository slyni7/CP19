--³Ø¼­½º ¾ÆÁ©¸®¾Æ
function c76859314.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,76859314+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c76859314.tg1)
	e1:SetOperation(c76859314.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76859314,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,76859315)
	e2:SetCondition(c76859314.con2)
	e2:SetCost(c76859314.cost2)
	e2:SetTarget(c76859314.tg2)
	e2:SetOperation(c76859314.op2)
	c:RegisterEffect(e2)
end
function c76859314.tfilter11(c)
	return c:IsSetCard(0x2c5) and c:IsAbleToGrave()
end
function c76859314.tfilter12(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_TRAP) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and not c:IsCode(76859314) and c:CheckActivateEffect(false,true,false)~=nil
end
function c76859314.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		if e:GetLabel()==10000 then
			return chkc:IsControler(1-tp) and chkc:IsOnField()
		else
			local te=e:GetLabelObject()
			local tg=te:GetTarget()
			return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
		end
	end
	local v1=Duel.IsExistingMatchingCard(c76859314.tfilter11,tp,LOCATION_HAND,0,1,c) and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,2,nil)
	local v2=Duel.IsExistingTarget(c76859314.tfilter12,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then
		return (v1 or v2)
	end
	if v1 and v2 then
		local opt=Duel.SelectOption(tp,aux.Stringid(76859314,1),aux.Stringid(76859314,2))
		e:SetLabel(opt+10000)
	elseif v1 then
		e:SetLabel(10000)
	else
		e:SetLabel(10001)
	end
	if e:GetLabel()==10000 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,2,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local g=Duel.SelectTarget(tp,c76859314.tfilter12,tp,LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
		Duel.ClearTargetCard()
		tc:CreateEffectRelation(e)
		local tg=te:GetTarget()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		if tg then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		end
		te:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(te)
	end
end
function c76859314.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==10000 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c76859314.tfilter11,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
			Duel.Destroy(tg,REASON_EFFECT)
		end
	else
		local te=e:GetLabelObject()
		if not te then
			return
		end
		local tc=te:GetHandler()
		if not tc:IsRelateToEffect(e) then
			return
		end
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then
			op(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function c76859314.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c76859314.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c76859314.tfilter21(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x2c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76859314.tfilter22(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_TRAP) and c:IsSSetable() and not c:IsCode(76859314)
end
function c76859314.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c76859314.tfilter21,tp,LOCATION_DECK,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c76859314.tfilter22,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859314.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
		return
	end
	local g1=Duel.GetMatchingGroup(c76859314.tfilter21,tp,LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c76859314.tfilter22,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()<1 or g2:GetCount()<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc2=g2:Select(tp,1,1,nil)
	Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.SSet(tp,tc2:GetFirst())
end