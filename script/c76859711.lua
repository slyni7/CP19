--틴즈 프로세스 - 사토네
function c76859711.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetOperation(c76859711.op0)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c76859711.con1)
	e1:SetOperation(c76859711.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_ATKCHANGE)
	e2:SetCondition(c76859711.con2)
	e2:SetTarget(c76859711.tar2)
	e2:SetOperation(c76859711.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetCost(c76859711.cost3)
	e3:SetTarget(c76859711.tar3)
	e3:SetOperation(c76859711.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCountLimit(1,76859711)
	e4:SetCondition(c76859711.con4)
	e4:SetCost(c76859711.cost4)
	e4:SetTarget(c76859711.tar4)
	e4:SetOperation(c76859711.op4)
	c:RegisterEffect(e4)
	if not c76859711.glo_chk then
		c76859711.glo_chk=true
		c76859711[1]=0
		c76859711[2]=0
		c76859711[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c76859711.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(c76859711.gop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c76859711.gop3)
		Duel.RegisterEffect(ge3,0)
	end
end
function c76859711.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_COST) and re and re:IsActiveType(TYPE_MONSTER) and not c:IsReason(REASON_RETURN) then
		c:RegisterFlagEffect(76859711,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,0)
	end
end
function c76859711.con1(e,c)
	if c==nil then
		return true
	end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and c76859711[1]>0 and c76859711[2]>0 and c76859711[3]>0
end
function c76859711.op1(e,tp,eg,ep,ev,re,r,rp,c)
	c76859711[1]=c76859711[1]-1
	c76859711[2]=c76859711[2]-1
	c76859711[3]=c76859711[3]-1
end
function c76859711.nfil1(c,tp)
	return c:IsSetCard(0x2c0) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp)
end
function c76859711.con2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c76859711.nfil1,1,nil,tp)
end
function c76859711.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if ckh==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c76859711.ofil2(c,e,re,tp)
	return c:IsSetCard(0x2c0) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp) and c:GetAttack()>=600
		and c:IsRelateToEffect(re) and not c:IsImmuneToEffect(e)
end
function c76859711.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c76859711.ofil2,nil,e,re,tp)
	if not c:IsFaceup() or not c:IsRelateToEffect(e) or Duel.GetCurrentChain()~=ev+1 or g:GetCount()<1 then
		return
	end
	if Duel.NegateActivation(ev) then
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(-600)
		tc:RegisterEffect(e1)
	end
end
function c76859711.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c76859711.tfil3(c)
	return c:IsSetCard(0x2c0) and c:IsSummonable(true,nil) and not c:IsCode(76859711)
end
function c76859711.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859711.tfil3,tp,LOCATION_HAND,0,1,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c76859711.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c76859711.tfil3,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function c76859711.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(76859711)>0
end
function c76859711.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c76859711.tfil4(c,e,tp)
	return c:IsSetCard(0x2c0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and (c:IsCode(76859711) or c:IsLevelBelow(4))
end
function c76859711.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c76859711.tfil4,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859711.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76859711.tfil4,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c76859711.gop1(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) then
		c76859711[1]=c76859711[1]+1
	end
	if re:IsActiveType(TYPE_SPELL) then
		c76859711[2]=c76859711[2]+1
	end
	if re:IsActiveType(TYPE_TRAP) then
		c76859711[3]=c76859711[3]+1
	end
end
function c76859711.gop2(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) then
		c76859711[1]=c76859711[1]-1
	end
	if re:IsActiveType(TYPE_SPELL) then
		c76859711[2]=c76859711[2]-1
	end
	if re:IsActiveType(TYPE_TRAP) then
		c76859711[3]=c76859711[3]-1
	end
end
function c76859711.gop3(e,tp,eg,ep,ev,re,r,rp)
	c76859711[1]=0
	c76859711[2]=0
	c76859711[3]=0
end