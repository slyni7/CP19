--hyotan: sokei

function c81030100.initial_effect(c)

	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81030100+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81030100.drco)
	e1:SetTarget(c81030100.drtg)
	e1:SetOperation(c81030100.drop)
	c:RegisterEffect(e1)
	
	--ATK / DEF update
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81030100,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c81030100.adco)
	e2:SetTarget(c81030100.adtg)
	e2:SetOperation(c81030100.adop)
	c:RegisterEffect(e2)
	
end

--draw
function c81030100.filter1(c)
	return c:IsDestructable() and c:IsSetCard(0xca3) 
	and ( c:IsLocation(LOCATION_HAND) or ( c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) ) )
end
function c81030100.drco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81030100.filter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c81030100.filter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
	Duel.Destroy(g,REASON_COST)
end
function c81030100.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function c81030100.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--ATK / DEF update
function c81030100.adco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c81030100.adtgfilter(c)
	return c:IsSetCard(0xca3)
		and c:IsFaceup()
		and c:IsType(TYPE_MONSTER)
end
function c81030100.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c81030100.adtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81030100.adtgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81030100.adtgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c81030100.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
