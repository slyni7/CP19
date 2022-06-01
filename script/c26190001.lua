--파란 달의 요정
function c26190001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMONABLE_CARD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c26190001.con1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REVIVE_LIMIT)
	e2:SetCondition(c26190001.con2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetValue(TYPE_RITUAL)
	e3:SetCondition(c26190001.con3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCountLimit(1,26190001)
	e4:SetTarget(c26190001.tar4)
	e4:SetOperation(c26190001.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e5:SetCountLimit(1,26190002)
	e5:SetCondition(c26190001.con5)
	e5:SetTarget(c26190001.tar5)
	e5:SetOperation(c26190001.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SET_BASE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c26190001.val6)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(c26190001.op7)
	c:RegisterEffect(e7)
end
function c26190001.con1(e)
	local c=e:GetHandler()
	return not c:IsType(TYPE_RITUAL)
end
function c26190001.con2(e)
	local c=e:GetHandler()
	return c:IsType(TYPE_RITUAL)
end
function c26190001.con3(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_HAND) or (c:GetSummonType()&SUMMON_TYPE_NORMAL==SUMMON_TYPE_NORMAL)
end
function c26190001.tfil4(c)
	return c:IsCode(26190004) and c:IsAbleToHand()
end
function c26190001.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c26190001.tfil4,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26190001.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c26190001.tfil4,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c26190001.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()&SUMMON_TYPE_RITUAL==SUMMON_TYPE_RITUAL
end
function c26190001.tar5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local c=e:GetHandler()
	local ct=math.floor(c:GetLevel()/4)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c26190001.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(-4*ct)
			c:RegisterEffect(e1)
			local lv=c:GetLevel()
			if lv>5 and c:IsFaceup() and c:IsRelateToEffect(e)
				and Duel.IsPlayerCanDraw(tp,math.floor(c:GetLevel()/6))
				and Duel.SelectYesNo(tp,aux.Stringid(26190001,0)) then
				Duel.BreakEffect()
				Duel.Draw(tp,math.floor(c:GetLevel()/6),REASON_EFFECT)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(1)
				c:RegisterEffect(e1)
			end
		end
	end
end
function c26190001.val6(e,c)
	return math.min(c:GetLevel()*400,1400+c:GetLevel()*200)
end
function c26190001.op7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetLevel()<6 and c:IsType(TYPE_RITUAL) then
		Duel.Hint(HINT_CARD,0,26190001)
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end