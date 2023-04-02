--가상에서 현실로
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		c:Code(23846921)
		Duel.PromisedEnd(tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ANYTIME)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			s[2](e,tp,eg,ep,ev,re,r,rp)
			end)
		Duel.RegisterEffect(e1,0)
	end)
	Duel.RegisterEffect(e1,0)
end

function string:split(delimiter)
	local result = {}
	local from = 1
	local delim_from,delim_to = string.find(self,delimiter,from)
	while delim_from do
		table.insert(result,string.sub(self,from,delim_from-1))
		from = delim_to + 1
		delim_from,delim_to = string.find(self,delimiter,from )
	end
	table.insert(result,string.sub(self,from))
	return result
end

s[2]=function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local playerop_seed=Debug.GetPlayerOpSeed()

	local playeropfilename
	if playerop_seed==0 then
		playeropfilename="playerop.log"
	else
		playeropfilename="playerop "..playerop_seed..".log"
	end

	local f=io.open(playeropfilename,"r")
	if f==nil then
		return
	end

	local fl=0

	local lastidles={}

	local lastchain=true

	--Debug.Message(playerop_seed)

	for line in f:lines() do
		local res=line:split(" ")
		if res[1]=="select_idle_command" then
			table.insert(lastidles,fl)
			lastidle=fl
		end
		if res[1]=="select_chain" then
			if res[3]=="-1" then
				lastchain=true
			else
				if lastchain then
					table.insert(lastidles,fl)
				end
				lastchain=false
			end
		end
		fl=fl+1
	end

	local idleindex = #lastidles - 1
	if Duel.GetCurrentChain()>0 then
		idleindex = idleindex - 1
	end
	--Debug.Message(idleindex)

	local latestidle = lastidles[idleindex]

	if latestidle==nil then
		f:close()
		return
	end

	f:close()

	local playeropvirtualfilename
	if playerop_seed==0 then
		playeropvirtualfilename="playeropvirtual.log"
	else
		playeropvirtualfilename="playeropvirtual "..playerop_seed..".log"
	end

	local vf=io.open(playeropvirtualfilename,"w")

	f=io.open(playeropfilename,"r")

	fl=0

	for line in f:lines() do
		vf:write(line.."\n")
		fl=fl+1
		if fl==latestidle then
			break
		end
	end
	vf:close()
	f:close()

	vf=io.open(playeropvirtualfilename,"r")

	f=io.open(playeropfilename,"w")

	for line in vf:lines() do
		f:write(line.."\n")
	end
	vf:close()
	f:close()

	local delf=io.open(playeropvirtualfilename,"w")
	delf:close()
	Debug.FromVirtualToReal(true)
end