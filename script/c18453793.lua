--전뇌천왕
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddDelightProcedure(c,s.pfil1,1,1)
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(s.tar1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_CANNOT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.tar2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","M")
	e3:SetCode(EVENT_TO_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCountLimit(1,id,EFFECT_COUNT_CODE_SINGLE)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e4)
end
s.custom_type=CUSTOMTYPE_DELIGHT
function s.pfil1(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevel(4) and c:IsRace(RACE_CYBERSE)
end
function s.tar1(e,c)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(tp)
end
function s.tar2(e,c)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(1-tp)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	local tc=g:GetFirst()
	while tc do
		tc:CreateEffectRelation(e)
		tc=g:GetNext()
	end
	return #g>0
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
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
	if chk==0 then
		return (ct2==0 or #gg2==#rg2)
	end
	local tg=eg:Filter(Card.IsRelateToEffect,nil,e)
	local rg=Group.CreateGroup()
	rg:Merge(rg2)
	rg:Merge(rg3)
	local rct=#tg+ct2+ct3
	Duel.SOI(0,CATEGORY_REMOVE,rg,rct,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
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
	if (ct2==0 or #gg2==#rg2) then
		local tg=eg:Filter(Card.IsRelateToEffect,nil,e)
		local rg4=Group.CreateGroup()
		local rg5=rg3:RandomSelect(tp,ct3)
		rg4:Merge(tg)
		rg4:Merge(rg2)
		rg4:Merge(rg5)
		Duel.DisableShuffleCheck()
		local hg=rg4:Filter(Card.IsLoc,nil,"H")
		local gg=rg4:Filter(Card.IsLoc,nil,"G")
		local xg=rg4:Filter(Card.IsLoc,nil,"DE")
		hg:KeepAlive()
		gg:KeepAlive()
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
		e1:SetCondition(s.ocon31)
		e1:SetOperation(s.oop31)
		e1:SetLabel(fid)
		e1:SetLabelObject({hg,gg,xg})
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.onfil31(c,fid)
	return c:GetFlagEffectLabel(id)==fid or c:GetFlagEffectLabel(id)==fid|0x80000000
end
function s.ocon31(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local hg,gg,xg=table.unpack(e:GetLabelObject())
	return hg:IsExists(s.onfil31,1,nil,fid) or gg:IsExists(s.onfil31,1,nil,fid) or xg:IsExists(s.onfil31,1,nil,fid)
end
function s.oofil31(c,fid)
	return c:GetFlagEffectLabel(id)==fid|0x80000000
end
function s.oop31(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local hg,gg,xg=table.unpack(e:GetLabelObject())
	Duel.SendtoHand(hg,nil,REASON_EFFECT+REASON_RETURN)
	Duel.SendtoGrave(gg,REASON_EFFECT+REASON_RETURN)
	local ug=xg:Filter(s.oofil31,nil,fid)
	xg:Sub(ug)
	Duel.SendtoDeck(xg,nil,2,REASON_EFFECT+REASON_RETURN)
	Duel.SendtoExtraP(ug,nil,REASON_EFFECT+REASON_RETURN)
	hg:DeleteGroup()
	gg:DeleteGroup()
	xg:DeleteGroup()
	e:Reset()
end