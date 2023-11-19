--레이트 블루머
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,id)
	local e1=MakeEff(token,"Qo")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	e1:SetCL(1,id)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCost(s.ocost11)
	Duel.RegisterEffect(e1,tp)
end
function s.ocost11(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,id-20000)==0
	local b2=Duel.GetFlagEffect(tp,id-10000)==0
	if chk==0 then
		return (Duel.GetTurnCount()~=e:GetLabel() or Duel.IsPlayerAffectedByEffect(tp,18453867))
			and (b1 or b2)
	end
	if Duel.GetTurnCount()==e:GetLabel() then
		local te=Duel.IsPlayerAffectedByEffect(tp,18453867)
		local tc=te:GetHandler()
		tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	if op==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
		Duel.RegisterFlagEffect(tp,id-20000,RESET_PHASE+PHASE_END,0,2)
		e:SetOperation(s.oop11)
	elseif op==2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
		Duel.RegisterFlagEffect(tp,id-10000,RESET_PHASE+PHASE_END,0,2)
		e:SetOperation(s.oop12)
	else
		e:SetOperation(s.oop13)
	end
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetTR("H",0)
	e1:SetCL(1)
	e1:SetTarget(function(e,c)
		return c:IsSetCard("레이트 블루")
	end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.oop12(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTR("S",0)
	e1:SetCL(1)
	e1:SetTarget(function(e,c)
		return c:IsSetCard("레이트 블루")
	end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.oop13(e,tp,eg,ep,ev,re,r,rp)
end