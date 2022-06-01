--μ(마이크로) 카나데
local m=11111120
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT<1 then
		return false
	end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x1f5)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local se=e:GetLabelObject()
	if chk==0 then
		return c:IsSummonable(true,se)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=e:GetLabelObject()
	if c:IsRelateToEffect(e) and c:IsSummonable(true,se) then
		Duel.Summon(tp,c,true,se)
	end
end