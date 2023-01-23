--패말림(H@NDTR@P)의 결말
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","H")
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tar2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	if s.global_check==nil then
		s.global_check=true
		s[0]=0
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_LEAVE_FIELD_P)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(s.gop2)
		ge2:SetLabelObject(ge1)
		Duel.RegisterEffect(ge2,0)
		local ge3=MakeEff(c,"FC")
		ge3:SetCode(EVENT_CHAINING)
		ge3:SetOperation(s.gop3)
		Duel.RegisterEffect(ge3,0)
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		for i=1,s[0] do
			local te=s[i]
			if te and tc:IsRelateToEffect(e) and te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:GetHandler()==tc
				and tc:IsStatus(STATUS_LEAVE_CONFIRMED) then
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_LEAVE,0,0)
			end
		end
		tc=eg:GetNext()
	end
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	if s[0]==0 then
		s[0]=Duel.GetCurrentChain()
	end
	s[Duel.GetCurrentChain()]=re
	local rc=re:GetHandler()
	local te=e:GetLabelObject()
	rc:CreateEffectRelation(te)
end
function s.gop3(e,tp,eg,ep,ev,re,r,rp)
	for i=1,s[0] do
		s[i]=nil
	end
	s[0]=0
end
function s.nfil2(c)
	return s.nfil21(c) or s.nfil22(c)
end
function s.nfil21(c)
	local r=c:GetReason()
	local re=c:GetReasonEffect()
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and re and r&REASON_COST~=0 and re:GetHandler()==c
end
function s.nfil22(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost() and c:GetFlagEffect(id)>0
end
function s.nfun2(sg,e,tp,mg)
	return sg:IsExists(s.nfil21,1,nil) and sg:IsExists(s.nfil22,2,nil)
end
function s.con2(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local rg=Duel.GMGroup(s.nfil2,tp,"G",0,nil)
	local ft=Duel.GetLocCount(tp,"M")
	return ft>0 and #rg>0 and aux.SelectUnselectGroup(rg,e,tp,3,3,s.nfun2,0)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=nil
	local rg=Duel.GMGroup(s.nfil2,tp,"G",0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,3,3,s.nfun2,1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	local tc=g:GetFirst()
	local tset={}
	while tc do
		if s.nfil21(tc) then
			local te=tc:GetReasonEffect()
			table.insert(tset,te)
		else
			table.insert(tset,tc)
		end
		tc=g:GetNext()
	end
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e3:SetLabelObject(tset)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function s.tfun3(te,tp,eg,ep,ev,re,r,rp,chain)
	local con=te:GetCondition()
	local co=te:GetCost()
	local tg=te:GetTarget()
	local res=false
	if te:GetCode()==EVENT_CHAINING then
		if chain>0 then
			local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local cc=ce:GetHandler()
			local cg=Group.FromCards(cc)
			local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
			if (not con or con(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp))
				and (not tg or tg(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp,0)) then
				res=true
			end
		end
	elseif te:GetCode()==EVENT_FREE_CHAIN then
		if (not con or con(te,tp,eg,ep,ev,re,r,rp))
			and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
			res=true
		end
	else
		local tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		if tres
			and (not con or con(te,tp,teg,tep,tev,tre,tr,trp))
			and (not tg or tg(te,tp,teg,tep,tev,tre,tr,trp,0)) then
			res=true
		end
	end
	return res
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local tset=e:GetLabelObject()
	local res=false
	local chain=Duel.GetCurrentChain()
	local tres={false,false,false}
	for i=1,#tset do
		if type(tset[i])=="Effect" then
			local sres=s.tfun3(tset[i],tp,eg,ep,ev,re,r,rp,chain)
			if sres then
				res=true
				tres[i]=true
			end
		else
			local tc=tset[i]
			local index=0
			local sres=false
			repeat
				local te=tc.eff_ct[tc][index]
				if te:IsHasType(EFFECT_TYPE_ACTIVATE) then
					local sres=s.tfun3(te,tp,eg,ep,ev,re,r,rp,chain)
					if sres then
						res=true
						tres[i]=true
						break
					end
				end
				index=index+1
			until not tc.eff_ct[tc][index]
		end
	end
	if chk==0 then
		return res
	end
	local sg=Group.CreateGroup()
	local tlab={}
	for i=1,#tres do
		if tres[i] then
			if type(tset[i])=="Effect" then
				local token=Duel.CreateToken(tp,tset[i]:GetHandler():GetOriginalCode())
				tlab[token]=i
				sg:AddCard(token)
			else
				local token=Duel.CreateToken(tp,tset[i]:GetOriginalCode())
				tlab[token]=i
				sg:AddCard(token)
			end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
	local ti=tlab[tc]
	local ae=nil
	if tset[ti]=="Effect" then
		ae=tset[ti]
	else
		local off=1
		local ops={}
		local opval={}
		local chain=Duel.GetCurrentChain()-1
		local index=0
		repeat
			local te=tc.eff_ct[tc][index]
			if te:IsHasType(EFFECT_TYPE_ACTIVATE) then
				local sres=s.tfun3(te,tp,eg,ep,ev,re,r,rp,chain)
				if sres then
					ops[off]=te:GetDescription()
					opval[off-1]=te
					off=off+1
				end
			end
			index=index+1
		until not tc.eff_ct[tc][index]
		if off==2 then
			ae=opval[0]
		else
			local op=Duel.SelectOption(tp,table.unpack(ops))
			ae=opval[op]
		end
	end
	e:SetCategory(ae:GetCategory())
	e:SetProperty(ae:GetProperty())
	local tg=ae:GetTarget()
	if ae:GetCode()==EVENT_CHAINING then
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		if tg then
			tg(e,tp,cg,cp,chain,ce,REASON_EFFECT,cp,1)
		end
	elseif ae:GetCode()==EVENT_FREE_CHAIN then
		if tg then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(ae:GetCode(),true)
		if tg then
			tg(e,tp,teg,tep,tev,tre,tr,trp,1)
		end
	end
	ae:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(ae)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetLabelObject()
	if not ae then
		return
	end
	local chain=Duel.GetCurrentChain()-1
	e:SetLabelObject(ae:GetLabelObject())
	local op=ae:GetOperation()
	if ae:GetCode()==EVENT_CHAINING then
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		if op then
			op(e,tp,cg,cp,chain,ce,REASON_EFFECT,cp)
		end
	elseif ae:GetCode()==EVENT_FREE_CHAIN then
		if op then
			op(e,tp,eg,ep,ev,re,r,rp)
		end
	else
		local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(ae:GetCode(),true)
		if op then
			op(e,tp,teg,tep,tev,tre,tr,trp)
		end
	end
end