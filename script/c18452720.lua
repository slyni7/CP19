--지니할로위즈
local m=18452720
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(18452720)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function cm.tfil2(c)
	return c:IsSetCard(0x2d2) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return cm.tfil2(chkc) and chkc:IsAbleToHand() and chkc:IsControler(tp)
			and chkc:IsLoc("R")
	end
	if chk==0 then
		return Duel.IEToHandTarget(cm.tfil2,tp,"R",0,1,nil)
	end
	local g=Duel.SAToHandTarget(tp,cm.tfil2,tp,"R",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end