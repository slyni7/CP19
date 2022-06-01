--플라나 탈리아
local m=18453260
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_DIFFUSION) then
		e:SetLabel(1)
	else
		e:SetLabel(2)
	end
	return true
end
function cm.tfil1(c,label)
	return c:IsAbleToHand() and
		((c:IsSetCard(0x2eb) and c:IsCustomType(CUSTOMTYPE_DIFFUSION) and not c:IsCode(m) and label==1)
			or (c:IsCode(122400000) and label==2))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil,e:GetLabel())
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil,e:GetLabel())
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_CANNOT_TO_HAND)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetLabel(tc:GetCode())
		e1:SetTarget(cm.otar11)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.otar11(e,c,tp,re)
	return c:IsCode(e:GetLabel()) and re and re:GetHandler():IsCode(m)
end