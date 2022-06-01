--틴즈 프로세스 - 쿠루미
function c76859703.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c76859703.con1)
	e1:SetOperation(c76859703.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetCountLimit(1,76859703)
	e2:SetCondition(c76859703.con2)
	e2:SetTarget(c76859703.tar2)
	e2:SetOperation(c76859703.op2)
	c:RegisterEffect(e2)
	if not c76859703.glo_chk then
		c76859703.glo_chk=true
		c76859703[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c76859703.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(c76859703.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c76859703.nfil1(c)
	return c:IsSetCard(0x2c0) and c:IsFaceup() and not c:IsCode(76859703)
end
function c76859703.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c76859703.nfil1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.CheckLPCost(tp,3100)
end
function c76859703.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,3100)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
	e1:SetValue(-1000)
	c:RegisterEffect(e1)
end
function c76859703.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c76859703.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c76859703.op2(e,tp,eg,ep,ev,re,r,rp)
	local v=c76859703[0]
	local s=0
	for i=1,v do
		local tc=c76859703[i]
		if tc:IsType(TYPE_MONSTER) then
			if tc:GetLevel()>0 then
				s=s+tc:GetLevel()
			end
			if tc:GetRank()>0 then
				s=s+tc:GetRank()
			end
		end
	end
	Duel.Recover(tp,s*100,REASON_EFFECT)
end
function c76859703.gop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	c76859703[0]=Duel.GetCurrentChain()
	c76859703[Duel.GetCurrentChain()]=rc
end
function c76859703.gop2(e,tp,eg,ep,ev,re,r,rp)
	local v=c76859703[0]
	for i=1,v do
		c76859703[i]=nil
	end
end