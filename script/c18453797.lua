--닫힌 결말인 메타픽션
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LSTN("R"),0,1,nil)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove(POS_FACEDOWN)
	end
	if chk==0 then
		return Duel.IETarget(Card.IsAbleToRemove,tp,0,"O",1,nil,POS_FACEDOWN)
	end
	local g=Duel.STarget(tp,Card.IsAbleToRemove,tp,0,"O",1,1,nil,POS_FACEDOWN)
	local ct2=Duel.GetFieldGroupCount(tp,0,LSTN("D"))
	if ct2>10 then
		ct2=10
	end
	local gg2=Duel.GetDecktopGroup(1-tp,ct2)
	local rg2=gg2:Filter(Card.IsAbleToRemove,nil,POS_FACEDOWN)
	local rg3=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"E",nil,POS_FACEDOWN)
	local ct3=#rg3
	if ct3>6 then
		ct3=6
	end
	local gct=1+ct2+ct3
	Duel.SOI(0,CATEGORY_REMOVE,g,gct,1-tp,"DE")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ct2=Duel.GetFieldGroupCount(tp,0,LSTN("D"))
	if ct2>10 then
		ct2=10
	end
	local gg2=Duel.GetDecktopGroup(1-tp,ct2)
	local rg2=gg2:Filter(Card.IsAbleToRemove,nil,POS_FACEDOWN)
	local rg3=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"E",nil,POS_FACEDOWN)
	local ct3=#rg3
	if ct3>6 then
		ct3=6
	end
	if tc:IsRelateToEffect(e) or ct2==0 or #gg2==#rg2 then
		local rg4=Group.CreateGroup()
		if tc:IsRelateToEffect(e) then
			rg4:AddCard(tc)
		end
		local rg5=rg3:RandomSelect(tp,ct3)
		rg4:Merge(rg2)
		rg4:Merge(rg5)
		Duel.DisableShuffleCheck()
		local fg=rg4:Filter(Card.IsLoc,nil,"O")
		local xg=rg4:Filter(Card.IsLoc,nil,"DE")
		fg:KeepAlive()
		xg:KeepAlive()
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
		local e1=MakeEff(c,"FC")
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(s.ocon11)
		e1:SetOperation(s.oop11)
		e1:SetLabel(fid)
		e1:SetLabelObject({fg,xg})
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.onfil11(c,fid)
	return c:GetFlagEffectLabel(id)==fid or c:GetFlagEffectLabel(id)==fid|0x80000000
end
function s.ocon11(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local fg,xg=table.unpack(e:GetLabelObject())
	return fg:IsExists(s.onfil11,1,nil,fid) or xg:IsExists(s.onfil11,1,nil,fid)
end
function s.oofil11(c,fid)
	return c:GetFlagEffectLabel(id)==fid|0x80000000
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local fg,xg=table.unpack(e:GetLabelObject())
	local fc=fg:GetFirst()
	while fc do
		Duel.ReturnToField(fc)
		fc=fg:GetNext()
	end
	local ug=xg:Filter(s.oofil11,nil,fid)
	xg:Sub(ug)
	Duel.SendtoDeck(xg,nil,2,REASON_EFFECT+REASON_RETURN)
	Duel.SendtoExtraP(ug,nil,REASON_EFFECT+REASON_RETURN)
	fg:DeleteGroup()
	xg:DeleteGroup()
	e:Reset()
end