--거짓된 이름을 지워라, 정화의 빛이여!
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"Qo","HM")
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"CO")
	c:RegisterEffect(e1)
end
s.square_mana={ATTRIBUTE_DIVINE,ATTRIBUTE_LIGHT,ATTRIBUTE_WIND,ATTRIBUTE_WATER}
s.custom_type=CUSTOMTYPE_SQUARE
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local reset=1
	if Duel.GetTurnPlayer()==tp then
		reset=2
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,reset)
	e1:SetTR(0x7f,0x7f)
	e1:SetTarget(s.otar11)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"F")
	e2:SetCode(id)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(1,1)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function s.otar11(e,c)
	return c:IsOriginalCodeRule(18453732) or c:IsOriginalCodeRule(111100100)
end