--오퍼레이션 아포칼립스
local m=18453522
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,cm.pfil1,cm.pfil2)
	local e1=MakeEff(c,"F","M")
	e1:SetCode(m)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTR(1,1)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e2,2,"CO")
	c:RegisterEffect(e2)
end
function cm.pfil1(c)
	return c:GetLevel()>0
end
function cm.pfil2(c)
	return c:GetLevel()==0
end
function cm.val1(e,sc,slv,stype)
	if slv==nil then
		return nil
	end
	return slv+1
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.cop21)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.cop21(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(m)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,1)
	e1:SetValue(cm.oval21)
	Duel.RegisterEffect(e1,tp)
end
function cm.oval21(e,sc,slv,stype)
	return slv*2
end