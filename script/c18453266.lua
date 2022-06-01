--플라나 체리아
local m=18453266
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,cm.pfil1,aux.NonTuner(nil),1)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_ATKCHANGE)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
end
function cm.pfil1(c)
	return c:IsSetCard(0x2eb) and c:IsType(TYPE_ORDER)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_SYNCHRO) then
		e:SetLabel(1)
	else
		e:SetLabel(2)
	end
	return true
end
function cm.tfil1(c)
	return c:IsAbleToHand() and c:IsSetCard(0x2eb) and c:IsLevel(16)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetLabel()~=1 or Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_ATKCHANGE)
		Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	else
		e:SetCategory(0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			if c:IsRelateToEffect(e) then
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_SET_ATTACK)
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(3200)
				c:RegisterEffect(e1)
			end
		end
	else
		if c:IsRelateToEffect(e) then
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(32)
			c:RegisterEffect(e1)
		end
	end
end