CUSTOMTYPE_SEQUENCE=0x20
REASON_SEQUENCE=0x500
SUMMON_TYPE_SEQUENCE=0x40006000

Auxiliary.SequenceCurrentChain={}

--[[reserved
Auxiliary.SequenceTemporaryChain={}]]--

Auxiliary.GlobalSavedSequences={}
Auxiliary.GlobalSavedSequences[0]={}
Auxiliary.GlobalSavedSequences[1]={}


local e1=Effect.GlobalEffect()
e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e1:SetCode(EVENT_CHAIN_SOLVED)
e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	table.insert(aux.SequenceCurrentChain,{re,rp})
	if ct==1 then
		local scct=#aux.SequenceCurrentChain
		local tempt={}
		for ocode,seqproc in pairs(aux.GlobalSequenceProcedures) do
			local spct=#seqproc
			local chkctotal={}
			local res=true
			for i=1,spct do
				chkctotal[i]=0
			end
			for i=1,scct do
				local scc=aux.SequenceCurrentChain[i]
				for j=1,spct do
					local spr=seqproc[j]
					if spr[1]==nil or spr[1](table.unpack(scc)) then
						chkctotal[j]=chkctotal[j]+1
					end
				end
			end
			for i=1,spct do
				local spr=seqproc[i]
				if chkctotal[i]<spr[2] or chkctotal[i]>spr[3] then
					res=false
					break
				end
			end
			if res then
				local sqc={}
				for i=1,scct do
					table.insert(sqc,i)
				end
				local res=false
				while true do
					local chkcpiece={}
					for i=1,spct do
						chkcpiece[i]=0
					end
					local sres=true
					for i=1,scct do
						local scc=aux.SequenceCurrentChain[sqc[i]]
						for j=1,spct do
							local spr=seqproc[j]
							if spr[1]==nil or spr[1](table.unpack(scc)) then
								if chkcpiece[j]<spr[2] then
									chkcpiece[j]=chkcpiece[j]+1
									break
								end
							end
						end
					end
					for i=1,spct do
						local spr=seqproc[i]
						if chkcpiece[i]<spr[2] then
							sres=false
							break
						end
					end
					if sres then
						res=true
						break
					end
					local final=true
					for i=1,scct do
						if sqc[i]~=scct+1-i then
							final=false
							break
						end
					end
					if final then
						break
					end
					local index=0
					for i=scct,2,-1 do
						if sqc[i]>sqc[i-1] then
							index=i-1
							break
						end
					end
					local used={}
					for i=1,index-1 do
						used[sqc[i]]=true
					end
					local new
					for i=1,scct do
						if used[i] or i<=sqc[index] then
						else
							new=i
							break
						end
					end
					sqc[index]=new
					used[new]=true
					for i=index+1,scct do
						local jnew=nil
						for j=1,scct do
							if used[j]==nil then
								jnew=j
								break
							end
						end
						sqc[i]=jnew
						used[jnew]=true
					end
				end
				if res then
					table.insert(tempt,{ocode,scct})
				end
			end
		end
		if #tempt>0 then
			for p=0,1 do
				table.insert(aux.GlobalSavedSequences[p],tempt)
			end
		end
		aux.SequenceCurrentChain={}
	end
end)
Duel.RegisterEffect(e1,0)

Auxiliary.GlobalCurrentSequences={}
Auxiliary.GlobalCurrentSequences[0]={}
Auxiliary.GlobalCurrentSequences[1]={}
local e2=Effect.GlobalEffect()
e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e2:SetCode(EVENT_FREE_CHAIN)
e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>0 then
		return false
	end
	for p=0,1 do
		aux.GlobalCurrentSequences[p]={}
		for i=1,#aux.GlobalSavedSequences[p] do
			table.insert(aux.GlobalCurrentSequences[p],aux.GlobalSavedSequences[p][i])
		end
		aux.GlobalSavedSequences[p]={}
	end
	return false
end)
Duel.RegisterEffect(e2,0)
local e3=e2:Clone()
Duel.RegisterEffect(e3,1)

Auxiliary.GlobalSequenceProcedures={}

function Auxiliary.AddSequenceProcedure(c,gf,...)
	local mt=getmetatable(c)
	if mt.sequence_procedure==nil then
		local spt={...}
		mt.sequence_procedure={}
		for i=1,math.floor(#spt/3) do
			local sptt={}
			for j=1,3 do
				table.insert(sptt,spt[(i-1)*3+j])
			end
			table.insert(mt.sequence_procedure,sptt)
		end
		aux.GlobalSequenceProcedures[c:GetOriginalCode()]=mt.sequence_procedure
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(aux.SequenceCondition)
	e1:SetOperation(aux.SequenceOperation)
	e1:SetDescription(0)
	e1:SetValue(SUMMON_TYPE_SEQUENCE)
	c:RegisterEffect(e1)
end

function Auxiliary.SequenceFilter(c,e,tp)
	local res1=false
	local res2=false
	for i=1,#aux.GlobalCurrentSequences[tp] do
		local tempt=aux.GlobalCurrentSequences[tp][i]
		for j=1,#tempt do
			local gcs=tempt[j]
			local gcode=gcs[1]
			local gcct=gcs[2]
			if gcode==c:GetOriginalCode() then
				res1=true
			end
			if gcct>=c:GetLevel() then
				res2=true
			end
		end
	end
	return res1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsForbidden()
		and (res2 or not c:IsLocation(LOCATION_DECK))
end
function Auxiliary.SequenceCondition(e,c,ischain,re,rp)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Auxiliary.SequenceFilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	return #g>0 and g:IsContains(c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function Auxiliary.SequenceFunction(sg,tp,sc)
	if sc and not sg:IsContains(sc) then
		return false
	end
	if #sg>#aux.GlobalCurrentSequences[tp] then
		return false
	end
	local res=false
	local cardt={}
	local tc=sg:GetFirst()
	while tc do
		table.insert(cardt,tc)
		tc=sg:GetNext()
	end
	local cardc={}
	local sct=#sg
	for i=1,sct do
		table.insert(cardc,i)
	end
	while true do
		local chkt={}
		local sres=true
		for i=1,sct do
			local tres=false
			local res1=false
			local res2=false
			local cc=cardt[cardc[i]]
			for j=1,#aux.GlobalCurrentSequences[tp] do
				local tempt=aux.GlobalCurrentSequences[tp][j]
				if chkt[j]==nil then
					for k=1,#tempt do
						local gcs=tempt[k]
						local gcode=gcs[1]
						local gcct=gcs[2]
						if gcode==cc:GetOriginalCode() then
							res1=true
						end
						if gcct>=cc:GetLevel() then
							res2=true
						end
						if res1 and (res2 or not cc:IsLocation(LOCATION_DECK)) then
							tres=true
							chkt[j]=true
							break
						end
					end
					if chkt[j] then
						break
					end
				end
			end
			if not tres then
				sres=false
				break
			end
		end
		if sres then
			res=true
			break
		end
		local final=true
		for i=1,sct do
			if cardc[i]~=sct+1-i then
				final=false
				break
			end
		end
		if final then
			break
		end
		local index=0
		for i=sct,2,-1 do
			if cardc[i]>cardc[i-1] then
				index=i-1
				break
			end
		end
		local used={}
			for i=1,index-1 do
			used[cardc[i]]=true
		end
		local new
		for i=1,sct do
			if used[i] or i<=cardc[index] then
			else
				new=i
				break
			end
		end
		cardc[index]=new
		used[new]=true
		for i=index+1,sct do
			local jnew=nil
			for j=1,sct do
				if used[j]==nil then
					jnew=j
					break
				end
			end
			cardc[i]=jnew
			used[jnew]=true
		end
	end
	return res
end
function Auxiliary.SequenceOperation(e,tp,eg,ep,ev,re,r,rp,c,sg,ischain)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Auxiliary.SequenceFilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local max=math.min(ct,#g)
	max=math.min(max,#aux.GlobalCurrentSequences[tp])
	local cancel=not ischain
	local inc=not ischain and c or nil
	local tg=g:SelectSubGroup(tp,Auxiliary.SequenceFunction,ischain,1,max,tp,inc)
	if tg then
		sg:Merge(tg)
	else
		for p=0,1 do
			for i=1,#aux.GlobalCurrentSequences[p] do
				table.insert(aux.GlobalSavedSequences[p],aux.GlobalCurrentSequences[p][i])
			end		
		end
	end
end

function Auxiliary.IsSequenceSummonable(tp)
	aux.GlobalCurrentSequences[tp]={}
	for i=1,#aux.GlobalSavedSequences[tp] do
		table.insert(aux.GlobalCurrentSequences[tp],aux.GlobalSavedSequences[tp][i])
	end
	aux.GlobalSavedSequences[tp]={}
	local result=Duel.IsPlayerCanProcedureSummonGroup(tp,SUMMON_TYPE_SEQUENCE)
	for i=1,#aux.GlobalCurrentSequences[tp] do
		table.insert(aux.GlobalSavedSequences[tp],aux.GlobalCurrentSequences[tp][i])
	end
	return result
end
function Auxiliary.SequenceSummon(tp)
	if Auxiliary.IsSequenceSummonable(tp) then
		aux.GlobalCurrentSequences[tp]={}
		for i=1,#aux.GlobalSavedSequences[tp] do
			table.insert(aux.GlobalCurrentSequences[tp],aux.GlobalSavedSequences[tp][i])
		end
		aux.GlobalSavedSequences[tp]={}
		Duel.ProcedureSummonGroup(tp,SUMMON_TYPE_SEQUENCE)
	end
end