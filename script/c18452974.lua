--충분히 발전한 과학은 마법과 구별할 수 없다
local m=18452974
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_CHAIN_DISABLED)
	e2:SetLabel(cid)
	e2:SetReset(RESET_CHAIN)
	e2:SetOperation(cm.cop12)
	Duel.RegisterEffect(e1,tp)
end
function cm.cop12(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then
		return
	end
	local c=e:GetOwner()
	if c:IsRelateToChain(ev) then
		c:CancelToGrave(false)
	end
end
function cm.tfil1(c)
	return c:IsFaceup() and c:IsCustomType(CUSTOMTYPE_SQUARE)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("M") and cm.tfil1(chkc)
	end
	if chk==0 then
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IETarget(cm.tfil1,tp,"M",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.STarget(tp,cm.tfil1,tp,"M",0,1,1,nil)
	Duel.SOI(0,CATEGORY_EQUIP,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLoc("S") then
		return
	end
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabel(tp)
		e1:SetValue(cm.oval11)
		c:RegisterEffect(e1)
		local e2=MakeEff(c,"FC","S")
		e2:SetCode(EVENT_CHAINING)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetOperation(cm.oop12)
		c:RegisterEffect(e2)
		local e3=MakeEff(c,"FC","S")
		e3:SetCode(EFFECT_DESTROY_REPLACE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetTarget(cm.otar13)
		e3:SetValue(cm.oval13)
		e3:SetOperation(cm.oop13)
		c:RegisterEffect(e3)
	else
		c:CancelToGrave(false)
	end
end
function cm.oval11(e,c)
	return c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsControler(e:GetLabel())
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and not rc:IsImmuneToEffect(e) then
		local att=rc:GetAttribute()
		local st=ec:GetSquareMana()
		local res=false
		for i=1,#st do
			if att==st[i] then
				res=true
				break
			end
		end
		if not res then
			return
		end
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
		e1:SetLabel(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.ooval121)
		ec:RegisterEffect(e1)
		Duel.NegateEffect(ev)
	end
end
function cm.ooval121(e,c)
	return e:GetLabel()
end
function cm.otar13(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then
		if not eg:IsContains(ec) or not ec:IsReason(REASON_BATTLE) or ec:IsReason(REASON_REPLACE) then
			return false
		end
		local bc=ec:GetBattleTarget()
		local att=bc:GetAttribute()
		local st=ec:GetSquareMana()
		local res=false
		for i=1,#st do
			if att==st[i] then
				res=true
				break
			end
		end
		return res
	end
	return true
end
function cm.oval13(e,c)
	local ec=e:GetHandler():GetEquipTarget()
	return c==ec
end
function cm.oop13(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local bc=ec:GetBattleTarget()
	local att=bc:GetAttribute()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
	e1:SetLabel(att)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(cm.ooval121)
	ec:RegisterEffect(e1)
end