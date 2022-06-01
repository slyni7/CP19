function c81070150.initial_effect(c)

	--act
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c81070150.atcn)
	c:RegisterEffect(e0)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81070150,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_NEGATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,81070150)
	e2:SetCost(c81070150.co)
	e2:SetTarget(c81070150.tg)
	e2:SetOperation(c81070150.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81070150,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c81070150.cn3)
	e3:SetTarget(c81070150.tg3)
	e3:SetOperation(c81070150.op3)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81070150,2))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c81070150.cn4)
	e4:SetTarget(c81070150.tg4)
	e4:SetOperation(c81070150.op4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c81070150.cn5)
	c:RegisterEffect(e5)

end

--activate
function c81070150.atcnfilter(c)
	return c:IsFaceup() 
	   and ( c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
end
function c81070150.atcn(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c81070150.atcnfilter,tp,LOCATION_ONFIELD,0,nil)==0
end

--effect[1]
function c81070150.cofilter(c)
	return c:IsSetCard(0xcaa) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
	and not c:IsCode(81070150)
end
function c81070150.co(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_DECK
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81070150.cofilter,tp,loc,0,1,nil)
	end
	local g=Duel.SelectMatchingCard(tp,c81070150.cofilter,tp,loc,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c81070150.tgfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsSetCard(0xcaa)
end
function c81070150.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c81070150.tgfilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81070150.tgfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c81070150.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,g,g:GetCount(),0,0)
end

function c81070150.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e4:SetValue(ATTRIBUTE_DARK)
		tc:RegisterEffect(e4)
		e:GetHandler():RegisterFlagEffect(81070150,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end

function c81070150.cn3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(81070150)~=0
end
function c81070150.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
end
function c81070150.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end

--effect[3]
function c81070150.cn4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST)
	and re:IsHasType(0x7e0) and re:GetHandler():IsSetCard(0xcaa)
end
function c81070150.cn5(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
	and e:GetHandler():GetPreviousControler()==tp
end

function c81070150.filter0(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xcaa) and not c:IsCode(81070150)
end
function c81070150.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_REMOVED+LOCATION_GRAVE
	if chkc then
		return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and chkc:IsAbleToDeck()
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81070150.filter0,tp,loc,0,3,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81070150.filter0,tp,loc,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end

function c81070150.op4(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then
		return
	end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
end