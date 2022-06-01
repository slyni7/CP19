--틴즈 프로젝트 - 카나데
function c76859708.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,76859708)
	e1:SetCost(c76859708.cost1)
	e1:SetTarget(c76859708.tar1)
	e1:SetOperation(c76859708.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetCondition(c76859708.con2)
	e2:SetTarget(c76859708.tar2)
	e2:SetOperation(c76859708.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+76859708)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetTarget(c76859708.tar3)
	e3:SetOperation(c76859708.op3)
	c:RegisterEffect(e3)
	if not c76859708.glo_chk then
		c76859708.glo_chk=true
		c76859708[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c76859708.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(c76859708.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c76859708.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c76859708.tfil1(c)
	return c:IsSetCard(0x2c0) and c:IsRace(RACE_FAIRY) and c:IsAbleToHand() and not c:IsCode(76859708)
end
function c76859708.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859708.tfil1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76859708.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859708.tfil1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c76859708.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c76859708.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,ev)
end
function c76859708.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end
function c76859708.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c76859708.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		e1:SetTarget(c76859708.tar31)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(c76859708.val32)
		e2:SetCondition(c76859708.con32)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetValue(1)
		c:RegisterEffect(e3)
	end
end
function c76859708.tar31(e,c)
	local h=e:GetHandler()
	if h:IsAttackPos() then
		return c:IsSetCard(0x2c0)
	else
		return false
	end
end
function c76859708.val32(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c76859708.nfil32(c)
	return c:IsSetCard(0x2c0) and c:IsFaceup() and not c:IsCode(76859708)
end
function c76859708.con32(e)
	local c=e:GetHandler()
	return c:IsDefensePos() and Duel.IsExistingMatchingCard(c76859708.nfil32,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c76859708.gop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>0 then
		c76859708[0]=c76859708[0]+eg:FilterCount(Card.IsSetCard,nil,0x2c0)
		if c76859708[0]>1 then
			Duel.RaiseEvent(eg,EVENT_CUSTOM+76859708,re,r,rp,0,0)
		end
	end
end
function c76859708.gop2(e,tp,eg,ep,ev,re,r,rp)
	c76859708[0]=0
end