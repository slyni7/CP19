--심연의 야상곡
--카드군 번호: 0xc90
function c81235060.initial_effect(c)

	c:SetUniqueOnField(1,0,81235060)
	
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c81235060.op1)
	c:RegisterEffect(e1)
	
	--스테이터스
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc90))
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c81235060.va2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
	--세트
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81235060,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,81235060)
	e4:SetCondition(c81235060.cn4)
	e4:SetTarget(c81235060.tg4)
	e4:SetOperation(c81235060.op4)
	c:RegisterEffect(e4)
end

--효과처리
function c81235060.filter0(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81235060.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then
		return
	end
	local g1=Duel.GetMatchingGroup(c81235060.filter0,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c81235060.filter0,tp,0,LOCATION_GRAVE,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81235060,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
	end
end

--스테이터스
function c81235060.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81235060.va2(e,c)
	return Duel.GetMatchingGroupCount(c81235060.filter1,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)*300
end

--세트
function c81235060.cfilter0(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81235060.cn4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c81235060.cfilter0,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)>=3
end
function c81235060.cfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c81235060.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_REMOVED) and c81235060.cfilter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81235060.cfilter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsPlayerCanDraw(1-tp,1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81235060.cfilter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
end
function c81235060.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(81235060,3)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
	end
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)		
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		if tc:IsType(TYPE_TRAP) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end


