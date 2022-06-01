--호른블로우
local m=99970561
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","G")
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(0xff,0xff)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetTarget(cm.tar2)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm[0]={}
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_HORNBLOW)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,m)>0 then
		return
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_STANDBY,0,2)
	local e1=MakeEff(c,"F",0xff)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCost(cm.ocost11)
	e1:SetTarget(cm.otar11)
	e1:SetOperation(cm.oop11)
	local e2=MakeEff(c,"FG")
	e2:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA
		,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
	e2:SetTarget(aux.TRUE)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	Duel.RegisterEffect(e2,tp)
end
function cm.ocost11(e,te,tp)
	local tc=te:GetHandler()
	table.insert(cm[0],tc:GetCode())
	local con=te:GetCondition()
	local cost=te:GetCost()
	local tar=te:GetTarget()
	local res=false
	local chain=Duel.GetCurrentChain()
	local event=te:GetCode()
	local tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
	if (not con or con(te,tp,teg,tep,tev,tre,tr,trp))
		and (not cost or cost(te,tp,teg,tep,tev,tre,tr,trp,0))
		and (not tar or tar(te,tp,teg,tep,tev,tre,tr,trp,0)) then
		res=true
	end
	table.remove(cm[0],#cm[0])
	return res
end
function cm.otar11(e,te,tp)
	local c=e:GetHandler()
	local tc=te:GetHandler()
	return c==tc
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.AnnounceCard(tp,c:GetCode(),OPCODE_ISCODE)
end
function cm.tar2(e,c)
	return #cm[0]>0 and c:IsCode(table.unpack(cm[0]))
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	table.insert(cm[0],ev)
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	cm[0]={}
end