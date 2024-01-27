--´©¸¥ ´«ÀÇ Åä·æ±âÈ²»ç
local m=18452874
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,18452874,35195612,true,true)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EVENT_CHAINING)
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_POSITION)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
cm.material_setcode="´©¸¥ ´«"
function cm.nfil1(c,tg,re,rp,ceg,cep,cev,cre,cr,crp)
	return c:IsCode(18452865) and c:IsFaceup() and c:IsCanBeEffectTarget(re) and tg(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return false
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g~=1 or not g:IsContains(c) then
		return false
	end
	local ceg,cep,cev,cre,cr,crp=Duel.GetChainEvent(ev)
	return Duel.IEMCard(cm.nfil1,tp,"O",0,1,nil,re:GetTarget(),re,rp,ceg,cep,cev,cre,cr,crp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,00)) then
		local ceg,cep,cev,cre,cr,crp=Duel.GetChainEvent(ev)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tg=Duel.SMCard(tp,cm.nfil1,tp,"O",0,1,1,nil,re:GetTarget(),re,rp,ceg,cep,cev,cre,cr,crp)
		Duel.HintSelection(tg)
		Duel.ChangeTargetCard(ev,tg)
	end
end
function cm.tfil2(c)
	return not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and cm.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.STarget(tp,cm.tfil2,tp,"M","M",1,1,nil)
	Duel.SOI(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE) then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end