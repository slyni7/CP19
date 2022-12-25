--황마방 에밀리아
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetD(id,0)
	e1:SetCL(1)
	WriteEff(e1,1,"CO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetD(id,1)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
s.square_mana={ATTRIBUTE_EARTH,ATTRIBUTE_EARTH}
s.custom_type=CUSTOMTYPE_SQUARE
function s.cfil1(c)
	return c:IsDiscardable() and c:GetLevel()>0
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.cfil1,tp,"H",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,s.cfil1,tp,"H",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	e:SetLabelObject(g:GetFirst())
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local tc=e:GetLabelObject()
		local att=tc:GetOriginalAttribute()
		local lv=tc:GetOriginalLevel()
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
	end
end
function s.tfil21(c,e,tp,ec)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then
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
		sg=Duel.GMGroup(s.tfil22,tp,"M",0,nil)
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
function s.tfil22(c)
	return c:IsSetCard("마방") and c:IsFaceup()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil21,tp,"D",0,1,nil,e,tp,c) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function s.ofun21(sg,tc,tp)
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
function s.ofil2(c,mst)
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
function s.ofun22(sg,st)
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
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil21,tp,"D",0,1,1,nil,e,tp,c)
	local tc=g:GetFirst()
	if not tc then
		return
	end
	local sg=Group.FromCards(c)
	if Duel.IsPlayerAffectedByEffect(tp,18453681) then
		sg=Duel.GMGroup(s.tfil22,tp,"M",0,nil)
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
	local msg=mg:SelectSubGroup(tp,s.ofun21,false,min,max,tc,tp)
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
			local og=sg:FilterSelect(tp,s.ofil2,1,1,nil,mst)
			local ost=og:GetFirst():GetSquareMana()
			local omg=Group.CreateGroup()
			for i=1,#ost do
				local token=Duel.CreateToken(tp,127800000+ost[i])
				omg:AddCard(token)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local max=math.min(#mst,#omg)
			local org=omg:SelectSubGroup(tp,s.ofun22,false,1,max,mst)
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
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end