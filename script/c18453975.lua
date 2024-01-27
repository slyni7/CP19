--폭염에 녹은 자
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddBraveProcedure(c,s.pfil1,2,2)
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTR("M",0)
	e1:SetValue(500)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_UPDATE_BRAVE)
	e2:SetTR("M",0)
	e2:SetValue(500)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
	e2:SetCondition(s.con1)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCL(1)
	WriteEff(e3,3,"CO")
	c:RegisterEffect(e3)
end
s.custom_type=CUSTOMTYPE_BRAVE
function s.pfil1(c)
	return not c:IsType(TYPE_TOKEN)
end
function s.con1(e)
	local tp=e:GetHandlerPlayer()
	local bz=aux.BurningZone[tp]
	local og=Group.CreateGroup()
	for i=1,#bz do
		og:AddCard(bz[i])
	end
	return og:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local bz=aux.BurningZone[tp]
	local og=Group.CreateGroup()
	for i=1,#bz do
		og:AddCard(bz[i])
	end
	if chk==0 then
		return og:IsExists(Card.IsAbleToDeckAsCost,1,nil)
	end
	local tg=og:FilterSelect(tp,Card.IsAbleToDeckAsCost,1,1,nil)
	aux.EraseFromBurningZone(tg)
	Duel.SendtoDeck(tg,nil,1,REASON_COST)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTR(0,1)
	e1:SetValue(s.oval31)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"F")
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(0,1)
	e2:SetTarget(s.otar32)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.oval31(e,re,tp)
	local og=Group.CreateGroup()
	for p=0,1 do
		local bz=aux.BurningZone[p]
		for i=1,#bz do
			og:AddCard(bz[i])
		end
	end
	local rc=re:GetHandler()
	return og:IsContains(rc)
end
function s.otar32(e,c)
	local og=Group.CreateGroup()
	for p=0,1 do
		local bz=aux.BurningZone[p]
		for i=1,#bz do
			og:AddCard(bz[i])
		end
	end
	return og:IsContains(c)
end