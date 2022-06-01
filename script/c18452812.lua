--데피니션 디파이너
local m=18452812
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_ADJUST)
	WriteEff(e1,1,"NO")
	Duel.RegisterEffect(e1,0)
	local e2=MakeEff(c,"STo")
	e2:SetCode(m)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_EQUIP)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"A")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
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
	local loc=c:GetLocation()
	if not ct then
		c:RegisterFlagEffect(m+10000000,0,0,0,loc)
	end
	if loc~=ct then
		c:SetFlagEffectLabel(m+10000000,loc)
		if not c:IsReason(REASON_DRAW) and not c:IsStatus(STATUS_SUMMONING) then
			Duel.RaiseSingleEvent(c,m,c:GetReasonEffect(),c:GetReason(),c:GetReasonPlayer(),c:GetReasonPlayer(),0)
		end
	end
end
function cm.tfil21(c,tp)
	return c:IsSetCard(0x2d6) and c:IsType(TYPE_UNION) and Duel.IEMCard(cm.tfil22,tp,"M",0,1,nil,c)
end
function cm.tfil22(c,ec)
	return c:IsFaceup() and ec:CheckUnionTarget(c) and aux.CheckUnionEquip(ec,c)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil21,tp,"HDG",0,1,nil,tp) and Duel.GetLocCount(tp,"S")>0
	end
	Duel.SOI(0,CATEGORY_EQUIP,nil,1,tp,"HDG")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"S")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SMCard(tp,cm.tfil21,tp,"HDG",0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=Duel.SMCard(tp,cm.tfil22,tp,"M",0,1,1,nil,tc)
		local ec=sg:GetFirst()
		if ec and aux.CheckUnionEquip(tc,ec) and Duel.Equip(tp,tc,ec) then
			aux.SetUnionState(tc)
		end
	end
end
function cm.tfil3(c)
	return c:IsSetCard(0x2d6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end