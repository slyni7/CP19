--두 번째 계절: 여름
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCL(1,id)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e2:SetCL(1,{id,1})
	WriteEff(e2,1,"N")
	WriteEff(e2,2,"CO")
	c:RegisterEffect(e2)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Damage(1-tp,700,REASON_EFFECT)
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTR(0,"M")
	e1:SetValue(-700)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end