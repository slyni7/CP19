--»≤≈‰≈∫
local m=18452876
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_RECOVER)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_ATTACK,cm.afil1)
end
function cm.afil1(c)
	return not c:IsCode(18452865)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_ATTACK)<1
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(LSTN("M"),LSTN("M"))
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,18452865))
	Duel.RegisterEffect(e1,tp)
end
function cm.tfil1(c)
	return c:IsFaceup() and c:IsCode(18452865) and not c:IsType(TYPE_LINK)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("M") and cm.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil1,tp,"M",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,cm.tfil1,tp,"M",0,1,1,nil)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Recover(tp,tc:GetBaseDefense(),REASON_EFFECT)
	end
end