--Angel Notes - 카시오페아
local m=18452803
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,aux.FilterBoolFunction(Card.IsModuleRace,RACE_FAIRY),nil,1,5,nil)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_EQUIP)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_EQUIP)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTf","M")
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_EQUIP)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_MODULE)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then	
		return chkc:IsType(TYPE_MONSTER) and chkc:IsControler(tp) and chkc:IsLoc("G")
	end
	if chk==0 then
		return Duel.IETarget(Card.IsType,tp,"G",0,1,nil,TYPE_MONSTER) and Duel.GetLocCount(tp,"S")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.STarget(tp,Card.IsType,tp,"G",0,1,1,nil,TYPE_MONSTER)
	Duel.SOI(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and c:IsFaceup() and Duel.Equip(tp,tc,c) then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.oval11)
		tc:RegisterEffect(e1)
		local e2=MakeEff(c,"E")
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(cm.oval12)
		tc:RegisterEffect(e2)
	end
end
function cm.oval11(e,c)
	return e:GetOwner()==c
end
function cm.oval12(e,te)
	return e:GetHandler()~=te:GetOwner() and te:IsActiveType(TYPE_MONSTER)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m)+Duel.GetFlagEffect(tp,m+1)<1 or Duel.IsPlayerAffectedByEffect(tp,76859118)
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.tfil2(c)
	return c:IsType(TYPE_MODULE)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"E",0,1,nil) and Duel.GetLocCount(tp,"S")>0
	end
	Duel.SOI(0,CATEGORY_EQUIP,nil,1,tp,"E")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetLocCount(tp,"S")>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SMCard(tp,cm.tfil2,tp,"E",0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,tc,c)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.oval11)
			tc:RegisterEffect(e1)
			local e2=MakeEff(c,"FTo","S")
			e2:SetCode(EVENT_BATTLE_START)
			e2:SetCategory(CATEGORY_EQUIP)
			e2:SetCountLimit(1)
			e2:SetCondition(cm.ocon22)
			e2:SetTarget(cm.otar22)
			e2:SetOperation(cm.oop22)
			tc:RegisterEffect(e2)
		end
	end
end
function cm.ocon22(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local bc=ec:GetBattleTarget()
	return ec:IsRelateToBattle() and bc
end
function cm.otar22(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local bc=ec:GetBattleTarget()
	if chk==0 then
		return Duel.GetLocCount(tp,"S")>0
	end
	Duel.SOI(0,CATEGORY_EQUIP,bc,1,0,0)
end
function cm.oop22(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local bc=ec:GetBattleTarget()
	if c:IsRelateToEffect(e) and ec:IsRelateToBattle() and bc:IsRelateToBattle() then
		Duel.Equip(tp,bc,ec)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(ec)
		e1:SetValue(cm.ooval21)
		bc:RegisterEffect(e1)
	end
end
function cm.ooval21(e,c)
	return e:GetLabelObject()==c
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return (Duel.GetFlagEffect(tp,m)<1 or Duel.IsPlayerAffectedByEffect(tp,76859118))
			and Duel.GetFlagEffect(tp,m+1)<1
	end
	Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.ofil31(c)
	return cm.ofil32(c) and c:IsAbleToHand()
end
function cm.ofil32(c)
	return c:GetType()&TYPE_EQUIP+TYPE_SPELL==TYPE_EQUIP+TYPE_SPELL
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GMGroup(aux.AngelNotesCantabileFilter,tp,"D",0,nil,c)
	local sg=Duel.GMGroup(aux.AngelNotesQuickFilter,tp,"D",0,nil)
	local res=false
	if #cg>0 and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(76859118,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local cc=cg:Select(tp,1,1,nil)
		Duel.SendtoGrave(cc,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sc=sg:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		if #sc>0 then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tg=Duel.SMCard(tp,aux.TRUE,tp,"O","O",1,1,c)
			local tc=tg:GetFirst()
			if tc then
				Duel.Equip(tp,tc,c)
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.oval11)
				tc:RegisterEffect(e1)
			end
		end
		res=true
	end
	if res then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.ofil31,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		if Duel.IEMCard(cm.ofil32,tp,"D",0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tg=Duel.SMCard(tp,aux.TRUE,tp,"O","O",1,1,c)
			local tc=tg:GetFirst()
			if tc then
				Duel.Equip(tp,tc,c)
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.oval11)
				tc:RegisterEffect(e1)
			end
		end
	end
end