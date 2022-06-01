--색의 폭주
local m=18453185
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"E")
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetValue(YuL.ATT("FELNWD"))
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_EQUIP)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLoc("M") and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsFaceup,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.STarget(tp,Card.IsFaceup,tp,"M","M",1,1,nil)
	Duel.SOI(0,CATEGORY_EQUIP,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc) 
	end
end
function cm.tfil41(c,tp)
	return Duel.IETarget(cm.tfil42,tp,"G",0,1,nil,c:GetAttribute())
end
function cm.tfil42(c,att)
	return c:IsType(TYPE_MONSTER) and c:GetAttribute()==att
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil41,tp,"M",0,1,nil,tp) and Duel.GetLocCount(tp,"S")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.STarget(tp,cm.tfil41,tp,"M",0,1,1,nil,tp)
	local tc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.STarget(tp,cm.tfil42,tp,"G",0,1,1,nil,tc:GetAttribute())
	local ec=g2:GetFirst()
	e:SetLabelObject(ec)
	Duel.SOI(0,CATEGORY_EQUIP,g2,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"S")<1 then
		return
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ec=e:GetLabelObject()
	local tc=g:GetFirst()
	if tc==ec then
		tc=g:GetNext()
	end
	if tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToEffect(e) and ec:IsRelateToEffect(e) and Duel.Equip(tp,ec,tc) then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(cm.oval41)
		ec:RegisterEffect(e1)
	end
end
function cm.oval41(e,c)
	return e:GetLabelObject()==c
end