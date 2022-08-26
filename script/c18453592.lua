--노킹 온 헤븐스 도어
local cm,m=GetID()
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"NCO")
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm[0]=true
		cm[1]=Group.CreateGroup()
		cm[1]:KeepAlive()
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=MakeEff(c,"FC")
		ge3:SetCode(EVENT_CHAIN_DISABLED)
		ge3:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge3,0)
		local ge4=MakeEff(c,"FC")
		ge4:SetCode(EVENT_ADJUST)
		ge4:SetOperation(cm.gop4)
		Duel.RegisterEffect(ge4,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=true
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=false
end
function cm.gofil41(c)
	return c:IsOnField() and c:IsDisabled()
end
function cm.gofil42(c)
	return not c:IsDisabled()
end
function cm.gop4(e,tp,eg,ep,ev,re,r,rp)
	if cm[1]:IsExists(cm.gofil41,1,nil) then
		cm[0]=false
	end
	local sg=Duel.GMGroup(cm.gofil42,tp,"O","O",nil)
	cm[1]=sg
	cm[1]:KeepAlive()
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return cm[0]
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
	local e3=MakeEff(c,"F")
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	e3:SetTR("O","O")
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
end