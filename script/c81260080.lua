--펑크랙 레이드
--카드군 번호: 0xcbf
function c81260080.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81260080)	
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c81260080.tg1)
	e1:SetOperation(c81260080.op1)
	c:RegisterEffect(e1)
	
	--회수
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81260080,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81260080)
	e2:SetCondition(c81260080.cn2)
	e2:SetTarget(c81260080.tg2)
	e2:SetOperation(c81260080.op2)
	c:RegisterEffect(e2)
end

--발동
function c81260080.filter0(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf)
end
function c81260080.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return true
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81260080.filter0,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,0x10+0x0c,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c81260080.filter0,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,0x10+0x0c,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,g2:GetCount(),0,0)
end
function c81260080.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and lc:IsRelateToEffect(e) and lc:IsControler(1-tp) then
		Duel.Remove(lc,POS_FACEUP,REASON_EFFECT)
	end
end

--회수
function c81260080.filter1(c,tp)
	if not c:IsSummonType(SUMMON_TYPE_SYNCHRO) then
		return false
	end
	return c:IsFaceup() and c:IsSetCard(0xcbf)
end
function c81260080.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81260080.filter1,1,nil,tp)
end
function c81260080.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return e:GetHandler():IsSSetable() 
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c81260080.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end


