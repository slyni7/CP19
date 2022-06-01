--틴즈 프로세스 - 릿카
function c76859706.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetOperation(c76859706.op0)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetDescription(aux.Stringid(76859706,0))
	e1:SetCondition(c76859706.con1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c76859706.con2)
	e2:SetOperation(c76859706.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(c76859706.val3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c76859706.con4)
	e4:SetTarget(c76859706.tar4)
	e4:SetValue(1000)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCategory(CATEGORY_SUMMON)
	e5:SetCost(c76859706.cost5)
	e5:SetTarget(c76859706.tar5)
	e5:SetOperation(c76859706.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetCountLimit(1,76859706)
	e6:SetCondition(c76859706.con6)
	e6:SetCost(c76859706.cost6)
	e6:SetTarget(c76859706.tar6)
	e6:SetOperation(c76859706.op6)
	c:RegisterEffect(e6)
	if not c76859706.glo_chk then
		c76859706.glo_chk=true
		c76859706[0]=0
		c76859706[1]=0
		c76859706[2]=0
		c76859706[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c76859706.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(c76859706.gop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c76859706.gop3)
		Duel.RegisterEffect(ge3,0)
	end
end
function c76859706.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_COST) and re and re:IsActiveType(TYPE_MONSTER) and not c:IsReason(REASON_RETURN) then
		c:RegisterFlagEffect(76859706,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,0)
	end
end
function c76859706.con1(e,c,minc)
	if c==nil then
		return true
	end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and c76859706[0]>0
end
function c76859706.con2(e,c)
	if c==nil then
		return true
	end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and c76859706[0]>0 and c76859706[1]>0 and c76859706[2]>0 and c76859706[3]>0
end
function c76859706.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0xfe0000)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
end
function c76859706.val3(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c76859706.nfil4(c)
	return c:IsFaceup() and c:GetAttack()>3100
end
function c76859706.con4(e)
	return Duel.IsExistingMatchingCard(c76859706.nfil4,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c76859706.tar4(e,c)
	return c:IsSetCard(0x2c0)
end
function c76859706.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c76859706.tfil5(c)
	return c:IsSetCard(0x2c0) and c:IsSummonable(true,nil) and not c:IsCode(76859706)
end
function c76859706.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859706.tfil5,tp,LOCATION_HAND,0,1,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c76859706.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c76859706.tfil5,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function c76859706.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(76859706)>0
end
function c76859706.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c76859706.tfil6(c,e,tp)
	return c:IsSetCard(0x2c0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and (c:IsCode(76859706) or c:IsLevelBelow(4))
end
function c76859706.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c76859706.tfil6,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859706.op6(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76859706.tfil6,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c76859706.gop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>3 then
		c76859706[0]=c76859706[0]+1
	end
	if re:IsActiveType(TYPE_MONSTER) then
		c76859706[1]=c76859706[1]+1
	end
	if re:IsActiveType(TYPE_SPELL) then
		c76859706[2]=c76859706[2]+1
	end
	if re:IsActiveType(TYPE_TRAP) then
		c76859706[3]=c76859706[3]+1
	end
end
function c76859706.gop2(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) then
		c76859706[1]=c76859706[1]-1
	end
	if re:IsActiveType(TYPE_SPELL) then
		c76859706[2]=c76859706[2]-1
	end
	if re:IsActiveType(TYPE_TRAP) then
		c76859706[3]=c76859706[3]-1
	end
end
function c76859706.gop3(e,tp,eg,ep,ev,re,r,rp)
	c76859706[0]=0
	c76859706[1]=0
	c76859706[2]=0
	c76859706[3]=0
end