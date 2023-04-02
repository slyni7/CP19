--퍼스트 디자이어
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCL(1,id)
	WriteEff(e1,1,"CO")
	c:RegisterEffect(e1)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(s.ocon11)
	e1:SetOperation(s.oop11)
	Duel.RegisterEffect(e1,tp)
end
function s.onfil11(c,tp)
	return c:IsPreviousLocation(LSTN("O")) and c:IsPreviousControler(1-tp) and not c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.ocon11(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.onfil11,1,nil,tp)
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(tp,1,REASON_EFFECT)
end