--KMS(메탈 블러드) 프린츠 오이겐
--카드군 번호: 0xcb5 -- KMS(메탈 블러드)
function c81180140.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcb5),2,3,nil,nil,99)
	
	--link meta
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81180140,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetTarget(c81180140.tg1)
	e1:SetOperation(c81180140.op1)
	c:RegisterEffect(e1)
	
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c81180140.va2)
	c:RegisterEffect(e2)
	
	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81180140,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81180140)
	e3:SetCondition(c81180140.cn3)
	e3:SetCost(c81180140.co3)
	e3:SetTarget(c81180140.tg3)
	e3:SetOperation(c81180140.op3)
	c:RegisterEffect(e3)
end

--link meta
function c81180140.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then
		return tc and tc:IsControler(1-tp) and tc:IsAbleToRemove(nil,POS_FACEDOWN) and tc:IsType(TYPE_LINK) 
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c81180140.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end

--immune
function c81180140.va2(e,te)
    return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end

--xyz
function c81180140.filter0(c,tp)
	return c:IsSetCard(0xcb5) and c:GetPreviousControler()==tp
end
function c81180140.cn3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81180140.filter0,1,nil,tp)
end
function c81180140.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c81180140.filter1(c)
	return c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcb5)
end
function c81180140.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81180140.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end
function c81180140.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c81180140.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
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


