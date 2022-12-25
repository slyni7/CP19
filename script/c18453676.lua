--천마방 새턴
local m=18453676
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.pfil1,2,false)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function cm.pfil1(c,fc,sub,mg,sg)
	if not c:IsSetCard("마방") then
		return false
	end
	if not sg or sg:FilterCount(aux.TRUE,c)==0 then
		return true
	end
	local g=sg:Clone()
	g:AddCard(c)
	local st=fc.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.ofil1(c)
	return c:IsSetCard("마방") and c:IsFaceup() and c:GetLevel()+c:GetRank()>0
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GMGroup(cm.ofil1,tp,"M",0,nil)
	local tc=sg:GetFirst()
	while tc do
		local att=tc:GetAttribute()
		local lv=tc:GetLevel()+tc:GetRank()
		local st={}
		for i=1,lv do
			table.insert(st,att)
		end
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(function(_,_)
			return table.unpack(st)
		end)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function cm.tfil21(c,e,tp,ec)
	if not c:IsAbleToRemove() or c:IsFacedown() then
		return false
	end
	local lv=c:GetLevel()
	local rk=c:GetRank()
	if lv+rk==0 then
		return false
	end
	local att=c:GetAttribute()
	local st={}
	local sg=Group.FromCards(ec)
	if Duel.IsPlayerAffectedByEffect(tp,18453681) then
		sg=Duel.GMGroup(cm.tfil22,tp,"M",0,nil)
	end
	local sc=sg:GetFirst()
	while sc do
		local cst=sc:GetSquareMana()
		for i=1,#cst do
			table.insert(st,cst[i])
		end
		sc=sg:GetNext()
	end
	local ct=0
	for i=1,#st do
		ct=ct+1
		if att==st[i] or (Duel.IsPlayerAffectedByEffect(tp,18453682) and st[i]~=0) then
			ct=ct+1
		end
	end
	return ct>=((lv+rk)<<1)
end
function cm.tfil22(c)
	return c:IsSetCard("마방") and c:IsFaceup()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.tfil21,tp,0,"MG",1,nil,e,tp,c)
	end
	Duel.SOI(0,CATEGORY_REMOVE,nil,1,tp,"MG")
end
function cm.ofun21(sg,tc,tp)
	local lv=tc:GetLevel()
	local rk=tc:GetRank()
	local att=tc:GetAttribute()
	local ct=0
	local sc=sg:GetFirst()
	while sc do
		ct=ct+1
		local scm=sc:GetCode()-127800000
		if att==scm or (Duel.IsPlayerAffectedByEffect(tp,18453682) and scm~=0) then
			ct=ct+1
		end
		sc=sg:GetNext()
	end
	return ct==((lv+rk)<<1)
end
function cm.ofil2(c,mst)
	local st=c:GetSquareMana()
	local res=false
	for i=1,#st do
		for j=1,#mst do
			if st[i]==mst[j] then
				res=true
			end
			if res then
				break
			end
		end
		if res then
			break
		end
	end
	return res
end
function cm.ofun22(sg,st)
	local mst={}
	local sc=sg:GetFirst()
	while sc do
		local scm=sc:GetCode()-127800000
		table.insert(mst,scm)
		sc=sg:GetNext()
	end
	local res=true
	local cst={}
	for i=1,#st do
		table.insert(cst,st[i])
	end
	for i=1,#mst do
		local sres=false
		for j=1,#cst do
			if mst[i]==cst[j] then
				sres=true
				table.remove(cst,j)
				break
			end
		end
		if not sres then
			res=false
			break
		end
	end
	return res
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,cm.tfil21,tp,0,"MG",1,1,nil,e,tp,c)
	local tc=g:GetFirst()
	if not tc then
		return
	end
	local sg=Group.FromCards(c)
	if Duel.IsPlayerAffectedByEffect(tp,18453681) then
		sg=Duel.GMGroup(cm.tfil22,tp,"M",0,nil)
	end
	local mg=Group.CreateGroup()
	local sc=sg:GetFirst()
	while sc do
		local cst=sc:GetSquareMana()
		for i=1,#cst do
			local token=Duel.CreateToken(tp,127800000+cst[i])
			mg:AddCard(token)
		end
		sc=sg:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local att=tc:GetAttribute()
	local min=tc:GetLevel()+tc:GetRank()
	local max=math.min((tc:GetLevel()+tc:GetRank())<<1,#mg)
	local msg=mg:SelectSubGroup(tp,cm.ofun21,false,min,max,tc,tp)
	if #sg==1 then
		local mst={}
		local msc=msg:GetFirst()
		while msc do
			local matt=msc:GetCode()-127800000
			table.insert(mst,matt)
			msc=msg:GetNext()
		end
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
		if Duel.IsPlayerAffectedByEffect(tp,18453681) then
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(function(_,_)
			return table.unpack(mst)
		end)
		sg:GetFirst():RegisterEffect(e1)
	else
		local mst={}
		local msc=msg:GetFirst()
		while msc do
			local matt=msc:GetCode()-127800000
			table.insert(mst,matt)
			msc=msg:GetNext()
		end
		while #mst>0 do
			local og=sg:FilterSelect(tp,cm.ofil2,1,1,nil,mst)
			local ost=og:GetFirst():GetSquareMana()
			local omg=Group.CreateGroup()
			for i=1,#ost do
				local token=Duel.CreateToken(tp,127800000+ost[i])
				omg:AddCard(token)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local max=math.min(#mst,#omg)
			local org=omg:SelectSubGroup(tp,cm.ofun22,false,1,max,mst)
			local ort={}
			local orc=org:GetFirst()
			while orc do
				local oatt=orc:GetCode()-127800000
				table.insert(ort,oatt)
				orc=org:GetNext()
			end
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(function(_,_)
				return table.unpack(ort)
			end)
			og:GetFirst():RegisterEffect(e1)
			for i=1,#ort do
				for j=1,#mst do
					if ort[i]==mst[j] then
						table.remove(mst,j)
						break
					end
				end
			end
		end
	end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTR("M","M")
		e1:SetTarget(cm.distg)
		e1:SetLabel(tc:GetOriginalCodeRule())
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=MakeEff(c,"FC")
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.discon)
		e2:SetOperation(cm.disop)
		e2:SetLabel(tc:GetOriginalCodeRule())
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return re:IsActiveType(TYPE_MONSTER) and (code1==code or code2==code)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)
end
