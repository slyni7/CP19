--DEF(데피니션)-언리미티드 데피니터
local m=18452811
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,nil,nil,1,2,cm.pfun1)
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_ADJUST)
	WriteEff(e1,1,"NO")
	Duel.RegisterEffect(e1,0)
	local e2=MakeEff(c,"STo")
	e2:SetCode(m)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCountLimit(1)
	e3:SetD(m,3)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetCountLimit(1)
	e4:SetD(m,4)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
end
function cm.pfun1(g)
	local tc=g:GetFirst()
	local ec=tc:GetEquipTarget()
	local sg=g:Clone()
	sg:AddCard(ec)
	return aux.dncheck(sg) and sg:FilterCount(Card.IsModuleSetCard,nil,0x2d6)==#sg
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
		if not c:IsStatus(STATUS_SUMMONING) then
			Duel.RaiseSingleEvent(c,m,c:GetReasonEffect(),c:GetReason(),c:GetReasonPlayer(),c:GetReasonPlayer(),0)
		end
	end
end
function cm.tfil21(c,e,tp,ec)
	return ((cm.tfil22(c,e,tp) and Duel.GetLocCount(tp,"M")>0)
		or (cm.tfil23(c,ec) and Duel.GetLocCount(tp,"S")>0))
		and c:IsFaceup() and c:IsSetCard(0x2d6) and c:IsType(TYPE_UNION)
end
function cm.tfun2(g,e,tp,ec)
	if not aux.dncheck(g) then
		return false
	end
	local mft=Duel.GetLocCount(tp,"M")
	local sft=Duel.GetLocCount(tp,"S")
	if g:FilterCount(cm.tfil22,nil,e,tp)==#g and #g<=mft then
		return true
	end
	if g:FilterCount(cm.tfil23,nil,ec)==#g and #g<=sft then
		return true
	end
	return false
end
function cm.tfil22(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tfil23(c,ec)
	return ec and c:CheckEquipTarget(ec) and aux.CheckUnionEquip(c,ec)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ec=c:IsLoc("M") and c:IsRelateToEffect(e) and c:IsFaceup() and c or nil
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("R") and cm.tfil21(chkc,e,tp,ec)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil21,tp,"R",0,1,nil,e,tp,c)
	end
	local g=Duel.GMGroup(cm.tfil21,tp,"R",0,nil,e,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,cm.tfun2,false,1,2,e,tp,ec)
	Duel.SetTargetCard(sg)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:IsLoc("M") and c:IsRelateToEffect(e) and c:IsFaceup() and c or nil
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local mft=Duel.GetLocCount(tp,"M")
	local sft=Duel.GetLocCount(tp,"S")
	local off=1
	local ops={}
	local opval={}
	local mct=g:FilterCount(cm.tfil22,nil,e,tp)
	if mct>0 and mft>0 then
		ops[off]=m,
		opval[off-1]=1
		off=off+1
	end
	local sct=g:FilterCount(cm.tfil23,nil,ec)
	if sct>0 and sft>0 then
		ops[off]=m,+1
		opval[off-1]=2
		off=off+1
	end
	if off==1 then
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		if mct>mft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g=g:Select(tp,mft,mft,nil)
		end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if ec and Duel.SelectYesNo(tp,aux.Stringid(m,0+2) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.SwapSequence(ec,tc)
		end
	elseif sel==2 then
		if mct>mft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			g=g:Select(tp,sft,sft,nil)
		end
		local tc=g:GetFirst()
		while tc do
			Duel.Equip(tp,tc,ec)
			aux.SetUnionState(tc)
			tc=g:GetNext()
		end
	end
end
function cm.cfil3(c)
	return c:IsSetCard(0x2d6) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil3,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,cm.cfil3,tp,"G",0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IETarget(aux.TRUE,tp,"O","O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,aux.TRUE,tp,"O","O",1,1,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then
		return false
	end
	return true
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsDiscardable,tp,"H",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,Card.IsDiscardable,tp,"H",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end