--영마방 제토
local m=18453678
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.pfil1,cm.pfun1,2,2,cm.pfil2,aux.Stringid(m,0),cm.pop1)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1)
	WriteEff(e2,2,"CO")
	c:RegisterEffect(e2)
end
function cm.pfil1(c,xc)
	return c:IsXyzLevel(xc,4) and c:IsCustomType(CUSTOMTYPE_SQUARE)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
function cm.pfil2(c)
	local st=cm.square_mana
	return c:IsFaceup() and c:IsSetCard("마방") and aux.IsFitSquare(Group.FromCards(c),st)
end
function cm.pop1(e,tp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m)==0
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	return true
end
cm.square_mana={0x0,0x0,0x0,0x0}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.val1(e,c)
	local ec=e:GetHandler()
	local og=ec:GetOverlayGroup()
	local t={}
	local tc=og:GetFirst()
	while tc do
		if tc:IsSetCard("마방") and tc:IsMonster() then
			local att=tc:GetAttribute()
			local lv=tc:GetLevel()
			for i=1,lv do
				table.insert(t,att)
			end
		end
		tc=og:GetNext()
	end
	return table.unpack(t)
end
function cm.cfil2(c,tp)
	return c:IsMonster() and c:GetLevel()+c:GetRank()>0 and (c:IsFaceup() or c:IsControler(tp))
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp)
	local og=c:GetOverlayGroup()
	g:Merge(og)
	local sg=g:Filter(cm.cfil2,c,tp)
	if chk==0 then
		return #sg>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	local tx=false
	if tc:IsLoc("X") then
		tx=true
	end
	Duel.SendtoGrave(tc,REASON_COST)
	if tx then
		Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	end
	e:SetLabelObject(tc)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local tc=e:GetLabelObject()
		local att=tc:GetOriginalAttribute()
		local lv=tc:GetOriginalLevel()+tc:GetOriginalRank()
		local st={}
		for i=1,lv do
			table.insert(st,att)
		end
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(function(_,_)
			return table.unpack(st)
		end)
		c:RegisterEffect(e1)
		local code=tc:GetOriginalCode()
		local e2=MakeEff(c,"S")
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetValue(code)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	end
end