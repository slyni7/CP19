--전부 빼앗아와서(에이프릴 메르헨)
local s,id=GetID()
function s.initial_effect(c)
	local e1=aux.AddEquipProcedure(c)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	local e2=MakeEff(c,"E")
	e2:SetCode(EFFECT_FINALE_STATE)
	e2:SetCondition(s.con2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","S")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetCL(1,{id,1})
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function s.con2(e)
	local c=e:GetHandler()
	return c:GetEquipTarget():IsCustomType(CUSTOMTYPE_EQUAL)
end
function s.cfil3(c,tp)
	return c:IsCode(18453725) and Duel.GetMZoneCount(tp,c)>0
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.CheckReleaseGroupCost(tp,s.cfil3,1,1,false,nil,nil,tp)
	end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfil3,1,1,false,nil,nil,tp)
	Duel.Release(g,REASON_COST)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if chk==0 then
		return tc:IsAbleToChangeControler()
	end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,Group.FromCards(tc),1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsFaceup()
		and tc:IsAbleToChangeControler() then
		local e1=MakeEff(c,"E")
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tp)
		c:RegisterEffect(e1)
	end
end