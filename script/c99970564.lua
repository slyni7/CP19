--파이로노미콘
local m=99970564
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","HS")
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	WriteEff(e1,1,"NC")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","S")
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(1,0)
	e2:SetValue(3)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F")
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCost(cm.cost3)	
	e3:SetTarget(cm.tar3)
	e3:SetOperation(cm.op3)
	e3:SetLabelObject(e1)
	Duel.RegisterEffect(e3,0)
	local e4=MakeEff(c,"FC",0xff)
	e4:SetCode(EVENT_ADJUST)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetLabelObject(e1)
	WriteEff(e4,4,"O")
	c:RegisterEffect(e4)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_HAND) or c:IsFacedown()
end
function cm.cfil1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	local p=c:GetFlagEffectLabel(m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil1,p,LOCATION_ONFIELD,0,3,3,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.cost3(e,te,tp)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.cfil1,tp,LOCATION_ONFIELD,0,3,c)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.cfil1,1-tp,LOCATION_ONFIELD,0,3,c)
	return b1 or b2
end
function cm.tar3(e,te,tp)
	local c=e:GetHandler()
	local tc=te:GetHandler()
	return te==e:GetLabelObject() and c==tc
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.cfil1,tp,LOCATION_ONFIELD,0,3,c)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.cfil1,1-tp,LOCATION_ONFIELD,0,3,c)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	c:RegisterFlagEffect(m,RESET_CHAIN,0,0)
	if opval[op]==1 then
		c:SetFlagEffectLabel(m,tp)
		if c:IsLocation(LOCATION_SZONE) then
			Duel.ChangePosition(c,POS_FACEUP)
		else
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
		end
	elseif opval[op]==2 then
		c:SetFlagEffectLabel(m,1-tp)
		Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,false)
	end
	e:GetLabelObject():SetType(EFFECT_TYPE_ACTIVATE)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_SZONE) and c:IsFaceup() then
		return
	end
	e:GetLabelObject():SetType(EFFECT_TYPE_IGNITION)
end