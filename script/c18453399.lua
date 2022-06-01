--미드나이트 스트롤러 ◆모듈라이즈!
local m=18453399
local cm=_G["c"..m]
function cm.initial_effect(c)
	RevLim(c)
	aux.AddModuleProcedure(c,aux.FilterBoolFunction(Card.IsModuleCode,18452804)
		,aux.FilterBoolFunction(Card.IsModuleCode,18452797),1,1,nil)
	local e1=MakeEff(c,"STf")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCL(1,m)
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTf","M")
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCL(1,m)
	WriteEff(e2,1,"NO")
	c:RegisterEffect(e2)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_MODULE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=6-Duel.GetFieldGroupCount(tp,LSTN("H"),0)
	if ct>0 then
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end