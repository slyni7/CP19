--[Forest]
local m=99970510
local cm=_G["c"..m]
function cm.initial_effect(c)

	--함정 몬스터
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	--카운터
	local e2=MakeEff(c,"I","M")
	e2:SetD(m,0)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetCL(1)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	
	--데미지 반감
	local e3=MakeEff(c,"Qo","M")
	e3:SetD(m,1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(spinel.tdcost)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)

end

--함정 몬스터
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,2000,2000,8,RACE_FIEND,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,2000,2000,8,RACE_FIEND,ATTRIBUTE_EARTH) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP)
end

--카운터
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,300) end
	local lp=Duel.GetLP(tp)
	local mp=math.floor(math.min(lp,1500)/300)
	local t={}
	for i=1,mp do
		t[i]=i*300
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(ac/300)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsCode(99970501)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1052,e:GetLabel(),REASON_EFFECT)
		tc=g:GetNext()
	end
end

--데미지 반감
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1 and e:GetHandler():GetCounter(0x1052)>0
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	cm[tp]=1
	if Duel.GetFlagEffect(tp,m)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.val)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.val(e,re,dam,r,rp,rc)
	if cm[e:GetOwnerPlayer()]==1 or bit.band(r,REASON_EFFECT)~=0 then
		return dam/2
	else return dam end
end
