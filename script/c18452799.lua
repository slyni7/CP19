--작도경-프톨레미러
local m=18452799
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddEquipProcedure(c)
	local e2=MakeEff(c,"E")
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","S")
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"CO")
	c:RegisterEffect(e3)
end
function cm.cfil3(c)
	return c:IsFacedown() and c:IsType(TYPE_MODULE)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil3,tp,"E",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SMCard(tp,cm.cfil3,tp,"E",0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local ec=c:GetEquipTarget()
	local tc=e:GetLabelObject()
	local code=tc:GetOriginalCode()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_ADD_MODULE_CODE)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(code)
	ec:RegisterEffect(e1)
	local race=tc:GetOriginalRace()
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_ADD_MODULE_RACE)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(race)
	ec:RegisterEffect(e2)
	local att=tc:GetOriginalAttribute()
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_ADD_MODULE_ATTRIBUTE)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
	e3:SetValue(att)
	ec:RegisterEffect(e3)
end