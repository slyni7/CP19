--모듈러 폼
local m=18452794
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsLevelAbove,3))
	local e2=MakeEff(c,"I","S")
	WriteEff(e2,2,"CO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then
		return ec and ec:GetLevel()>0 and c:IsAbleToGraveAsCost()
	end
	Duel.SetTargetCard(ec)
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel()*2)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function cm.tfil3(c)
	return c:IsCode(18452792) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end