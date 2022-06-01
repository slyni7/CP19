--작도검-파스칼리버
local m=18452798
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddEquipProcedure(c)
	local e2=MakeEff(c,"E")
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","S")
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"CO")
	c:RegisterEffect(e3)
end
function cm.cfil3(c)
	return c:GetType()&(TYPE_SPELL+TYPE_EQUIP)==(TYPE_SPELL+TYPE_EQUIP) and c:IsAbleToGraveAsCost() and not c:IsCode(m)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil3,tp,"D",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.cfil3,tp,"D",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local tc=e:GetLabelObject()
	local code=tc:GetOriginalCode()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_ADD_MODULE_CODE)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(code)
	c:RegisterEffect(e1)
end