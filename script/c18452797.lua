--모듈라이즈!
local m=18452797
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"E")
	e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_CHAIN_DISABLED)
	e2:SetReset(RESET_CHAIN)
	e2:SetLabel(cid)
	e2:SetOperation(cm.cop12)
	Duel.RegisterEffect(e2,tp)
end
function cm.cop12(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then
		return
	end
	if e:GetOwner():IsRelateToChain(ev) then
		e:GetOwner():CancelToGrave(false)
	end
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsFaceup() and chkc:IsControler(tp) and chkc:IsLoc("M")
	end
	if chk==0 then
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IETarget(Card.IsFaceup,tp,"M",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.STarget(tp,Card.IsFaceup,tp,"M",0,1,1,nil)
	Duel.SOI(0,CATEGORY_EQUIP,c,1,0,0)
end
function cm.ofil1(c)
	return c:IsType(TYPE_MODULE) and c:IsSpecialSummonable(SUMMON_TYPE_MODULE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) or not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local e2=MakeEff(c,"F","M")
		e2:SetCode(EFFECT_MUST_BE_MMATERIAL)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,cm.ofil1,tp,"E",0,0,1,nil)
		if #g>0 then
			Duel.SpecialSummonRule(tp,g:GetFirst(),SUMMON_TYPE_MODULE)
		end
	else
		c:CancelToGrave(false)
	end
end
function cm.val2(e,re,r,rp)
	return r&(REASON_BATTLE+REASON_EFFECT)>0
end