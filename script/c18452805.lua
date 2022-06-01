--D-데피니션 디파이너
local m=18452805
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,m)
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_ADJUST)
	WriteEff(e1,1,"NO")
	Duel.RegisterEffect(e1,0)
	local e2=MakeEff(c,"STo")
	e2:SetCode(m)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","M")
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","S")
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"E")
	e5:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetValue(cm.val5)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"E")
	e6:SetCode(EFFECT_UPDATE_LEVEL)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"E")
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(500)
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"E")
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	e8:SetValue(500)
	c:RegisterEffect(e8)
	local e9=MakeEff(c,"E")
	e9:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	local e10=MakeEff(c,"S")
	e10:SetCode(EFFECT_UNION_LIMIT)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetValue(cm.val10)
	c:RegisterEffect(e10)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(m+10000000)
	local loc=c:GetLocation()
	return not ct or loc~=ct
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(m+10000000)
	if not ct then
		c:RegisterFlagEffect(m+10000000,0,0,0)
	end
	local loc=c:GetLocation()
	if loc~=ct then
		c:SetFlagEffectLabel(m+10000000,loc)
		if not c:IsReason(REASON_DRAW) and not c:IsStatus(STATUS_SUMMONING) then
			Duel.RaiseSingleEvent(c,m,c:GetReasonEffect(),c:GetReason(),c:GetReasonPlayer(),c:GetReasonPlayer(),0)
		end
	end
end
function cm.tfil2(c)
	return c:IsSetCard(0x2d6) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"DO",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DO")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"DO",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.tfil3(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsSetCard(0x2d6) and c:IsFaceup() and not aux.IsCodeListed(c,m) and ct2<1
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLoc("M") and chkc:IsControler(tp) and cm.tfil3(chkc)
	end
	if chk==0 then
		return c:GetFlagEffect(m)<1 and Duel.GetLocCount(tp,"S")>0 and Duel.IETarget(cm.tfil3,tp,"M",0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.STarget(tp,cm.tfil3,tp,"M",0,1,1,c)
	Duel.SOI(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	if not tc:IsRelateToEffect(e) or not cm.tfil3(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then
		return
	end
	aux.SetUnionState(c)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)<1 and Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function cm.val5(e,re,r,rp)
	return r&(REASON_BATTLE+REASON_EFFECT)>0
end
function cm.val10(e,c)
	return (c:IsSetCard(0x2d6) and not aux.IsCodeListed(c,m)) or e:GetHandler():GetEquipTarget()==c
end