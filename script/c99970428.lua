--포가튼 스테이션
local m=99970428
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,cm.mod1,nil,1,1,nil)
	
	--드로우
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(spinel.drawtg(0,1))
	e1:SetOperation(spinel.drawop)
	c:RegisterEffect(e1)
	
	--튜너 변경, 공수 증가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(cm.atkcon)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)

end

--모듈 소환
function cm.mod1(c)
	return c:IsModuleAttribute(ATTRIBUTE_WATER) or c:IsType(TYPE_TUNER)
end

--드로우
function cm.cfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsAbleToDeckAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

--튜너 변경, 공수 증가
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO or r==REASON_MODULE
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	rc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	rc:RegisterEffect(e2,true)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetValue(TYPE_TUNER)
	rc:RegisterEffect(e3,true)
end
