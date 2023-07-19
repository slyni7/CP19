--메타픽션의 욕심쟁이 바비인형
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddDelightProcedure(c,s.pfil1,1,1)
	local e1=MakeEff(c,"S")
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCL(1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	if s.global_check==nil then
		s.global_check=true
		local ge1=MakeEff(c,"FC","M")
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC","M")
		ge2:SetCode(EVENT_SPSUMMON)
		ge2:SetOperation(s.gop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=MakeEff(c,"FC","M")
		ge3:SetCode(EVENT_SPSUMMON_NEGATED)
		ge3:SetOperation(s.gop3)
		Duel.RegisterEffect(ge3,0)
	end
end
s.custom_type=CUSTOMTYPE_DELIGHT
function s.pfil1(c)
	return c:IsSetCard("메타픽션")
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsCode(id) and tc:IsSummonType(SUMMON_TYPE_DELIGHT) then
			local sp=tc:GetSummonPlayer()
			Duel.RegisterFlagEffect(sp,id,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsCode(id) and tc:IsSummonType(SUMMON_TYPE_DELIGHT) then
			local sp=tc:GetSummonPlayer()
			Duel.RegisterFlagEffect(sp,id,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function s.gop3(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsCode(id) and tc:IsSummonType(SUMMON_TYPE_DELIGHT) then
			local sp=tc:GetSummonPlayer()
			Duel.ResetFlagEffect(sp,id)
		end
		tc=eg:GetNext()
	end
end
function s.val1(e,se,sp,st)
	return not (st&SUMMON_TYPE_DELIGHT==SUMMON_TYPE_DELIGHT and Duel.GetFlagEffect(sp,id)>0)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_DELIGHT)
end
function s.tfil2(c)
	return c:IsCode(18453790) and c:IsAbleToHand() and (c:IsFacedown() or c:IsLoc("D"))
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tfil2,tp,LSTN("DR"),0,nil)
	if chk==0 then
		return #g>0
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DR")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tfil2,tp,LSTN("DR"),0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLoc("M") and chkc:IsAbleToRemove(POS_FACEDOWN)
	end
	if chk==0 then
		return c:IsAbleToRemove(POS_FACEDOWN) and Duel.IETarget(Card.IsAbleToRemove,tp,0,"M",1,nil,POS_FACEDOWN)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.STarget(tp,Card.IsAbleToRemove,tp,0,"M",1,1,nil,POS_FACEDOWN)
	g:AddCard(c)
	Duel.SOI(0,CATEGORY_REMOVE,g,2,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ct2=Duel.GetFieldGroupCount(tp,0,LSTN("D"))
	if ct2>10 then
		ct2=10
	end
	local gg2=Duel.GetDecktopGroup(1-tp,ct2)
	local rg2=gg2:Filter(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)
	local rg3=Duel.GMGroup(Card.IsAbleToRemoveAsCost,tp,0,"E",nil,POS_FACEDOWN)
	if #rg2==#gg2 and #rg2==10 and #rg3>=6 and Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
		local rg4=Group.CreateGroup()
		local rg5=rg3:RandomSelect(tp,6)
		rg4:Merge(rg2)
		rg4:Merge(rg5)
		Duel.DisableShuffleCheck()
		rg4:KeepAlive()
		Duel.Remove(rg4,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local fid=c:GetFieldID()
		local rc4=rg4:GetFirst()
		while rc4 do
			local pos=rc4:GetPreviousPosition()
			local loc=rc4:GetPreviousLocation()
			if pos&POS_FACEUP~=0 and loc==LOCATION_EXTRA then
				rc4:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,fid|0x80000000)
			else
				rc4:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,fid)
			end
			rc4=rg4:GetNext()
		end
		local e2=MakeEff(c,"FC")
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetCondition(s.ocon32)
		e2:SetOperation(s.oop32)
		e2:SetLabel(fid)
		e2:SetLabelObject(rg4)
		e2:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e2,tp)
		Duel.NegateEffect(0)
		return
	else
		if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
			local g=Group.FromCards(c,tc)
			if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)>0 then
			local fid=c:GetFieldID()
				local og=Duel.GetOperatedGroup()
				local oc=og:GetFirst()
				while oc do
					oc:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
					oc=og:GetNext()
				end
				og:KeepAlive()
				local e1=MakeEff(c,"FC")
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(og)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetCondition(s.ocon31)
				e1:SetOperation(s.oop31)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.onfil31(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.ocon31(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(s.onfil31,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else
		return true
	end
end
function s.oop31(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=e:GetLabelObject()
	local sg=g:Filter(s.onfil31,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end
function s.onfil32(c,fid)
	return c:GetFlagEffectLabel(id)==fid or c:GetFlagEffectLabel(id)==fid|0x80000000
end
function s.ocon32(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local rg=e:GetLabelObject()
	return rg:IsExists(s.onfil31,1,nil,fid)
end
function s.oofil32(c,fid)
	return c:GetFlagEffectLabel(id)==fid|0x80000000
end
function s.oop32(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local rg=e:GetLabelObject()
	local ug=rg:Filter(s.oofil32,nil,fid)
	rg:Sub(ug)
	Duel.SendtoDeck(rg,nil,2,REASON_EFFECT+REASON_RETURN)
	Duel.SendtoExtraP(ug,nil,REASON_EFFECT+REASON_RETURN)
	rg:DeleteGroup()
	e:Reset()
end