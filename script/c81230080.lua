--역신의 분노
--카드군 번호: 0xcbc
function c81230080.initial_effect(c)

	c:EnableCounterPermit(0xcbc)
	
	--특수소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81230080.tg1)
	e1:SetOperation(c81230080.op1)
	c:RegisterEffect(e1)
	
	--공통 효과
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81230080,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetTarget(c81230080.tg2)
	e2:SetOperation(c81230080.op2)
	c:RegisterEffect(e2)
	
	--스탯 상승
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c81230080.va3)
	c:RegisterEffect(e3)
end

--특수소환
function c81230080.filter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xcbc)
	and ( c:IsLocation(LOCATION_GRAVE) or c:IsFaceup() )
end
function c81230080.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and c81230080.filter0(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81230080.filter0,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81230080.filter0,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c81230080.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then
			return
		end
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(c81230080.va1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c81230080.va1(e,c)
	return e:GetOwner()==c
end

--공통 효과
function c81230080.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xcbc) and c:IsCanAddCounter(0xcbc,1)
end
function c81230080.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(tp) and c81230030.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81230080.filter1,tp,LOCATION_ONFIELD,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,94)
	Duel.SelectTarget(tp,c81230080.filter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xcbc)
end
function c81230080.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0xcbc,1)
	end
end

--스탯 상승
function c81230080.va3(e,c)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0xcbc)*100
end


