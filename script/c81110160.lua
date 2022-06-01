--진벌의 잔화
--카드군 번호: 0xcae
function c81110160.initial_effect(c)

	c:EnableCounterPermit(0xcae)
	c:SetCounterLimit(0xcae,5)
	
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--카운터
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c81110160.cn2)
	e2:SetOperation(c81110160.op2)
	c:RegisterEffect(e2)
	
	--프리체인
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81110160,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCost(c81110160.co3)
	e3:SetTarget(c81110160.tg3)
	e3:SetOperation(c81110160.op3)
	c:RegisterEffect(e3)
	
	--드로우
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(c81110160.op5)
	c:RegisterEffect(e5)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81110160,3))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c81110160.cn4)
	e4:SetTarget(c81110160.tg4)
	e4:SetOperation(c81110160.op4)
	e4:SetLabelObject(e5)
	c:RegisterEffect(e4)
end

--카운터
function c81110160.cfil0(c,re)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
	and re:GetHandler():IsSetCard(0xcae)	
end
function c81110160.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81110160.cfil0,1,nil,re)
end
function c81110160.op2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1011,1)
end	

--파괴
function c81110160.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsCanRemoveCounter(tp,1,1,0x1011,2,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81110160,0))
	Duel.RemoveCounter(tp,1,1,0x1011,2,REASON_COST)
end
function c81110160.tfil0(c)
	return c:IsFaceup() and c:IsSetCard(0xcae)
end
function c81110160.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81110160.tfil0,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c81110160.tfil0,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c81110160.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end

--드로우
function c81110160.op5(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x1011)
	e:SetLabel(ct)
end

function c81110160.cn4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel()
	e:SetLabel(ct)
	return ct>1 and c:IsReason(REASON_DESTROY)
end
function c81110160.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local d=math.floor(e:GetLabelObject():GetLabel()/2)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(d)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,d)
end
function c81110160.op4(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if d>0 then
		Duel.Draw(p,d,REASON_EFFECT)
	end
end