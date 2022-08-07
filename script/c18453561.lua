--쇼팽 에튀드 25-10 옥타브
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		s[0]=0
		s.act_g=Group.CreateGroup()
		s.act_g:KeepAlive()
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(s.gop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=MakeEff(c,"FC")
		ge3:SetCode(EVENT_TO_GRAVE)
		ge3:SetOperation(s.gop3)
		Duel.RegisterEffect(ge3,0)
		local ge4=MakeEff(c,"FC")
		ge4:SetCode(EVENT_MOVE)
		ge4:SetOperation(s.gop4)
		Duel.RegisterEffect(ge4,0)
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	s[0]=Duel.GetCurrentChain()
	s[Duel.GetCurrentChain()]=re
	local rc=re:GetHandler()
	rc:RegisterFlagEffect(id,RESET_CHAIN+RESET_EVENT+RESET_TOFIELD,0,0)
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	local v=s[0]
	s[0]=0
	for i=1,v do
		s[i]=nil
	end
end
function s.gop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 and r==REASON_RULE then
		local tc=eg:GetFirst()
		while tc do
			local v=s[0]
			local tchk=false
			for i=1,v do
				local te=s[i]
				if te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:GetHandler()==tc
					and tc:GetFlagEffect(id)>0 then
					tchk=true
					break
				end
			end
			if tchk then
				s.act_g:AddCard(tc)
			end
			tc=eg:GetNext()
		end
	end
end
function s.gop4(e,tp,eg,ep,ev,re,r,rp)
	s.act_g:Remove(aux.NOT(Card.IsLoc),nil,"G")
end
function s.con1(e)
	local c=e:GetHandler()
	return c:IsPublic()
end
function s.tfil2(c,e,tp,eg,ep,ev,re,r,rp,chain)
	local chk_e={}
	if c:IsOnField() and c:IsFaceup() then
		for i=1,s[0] do
			local te=s[i]
			if c:IsRelateToEffect(te) then
				table.insert(chk_e,te)
			end
		end
	end
	if c:IsLoc("G") and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_COST) then
		local cre=c:GetReasonEffect()
		if cre and cre:GetHandler()==c then
			table.insert(chk_e,cre)
		end
	end
	if s.act_g:IsContains(c) then
		local i=0
		repeat
			local ae=c.eff_ct[c][i]
			if ae:IsHasType(EFFECT_TYPE_ACTIVATE) then
				table.insert(chk_e,ae)
			end
			i=i+1
		until not c.eff_ct[c][i]
	end
	local res=false
	for i=1,#chk_e do
		local te=chk_e[i]
		local tres,teg,tep,tev,tre,tr,trp
		if te:GetCode()==EVENT_CHAINING then
			local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local cc=ce:GetHandler()
			local cg=Group.FromCards(cc)
			local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
			teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
		elseif te:GetCode()==EVENT_FREE_CHAIN then
			teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
		else
			tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		end
		res=(not con or con(e,tp,teg,tep,tev,tre,tr,trp)) and (not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0))
		if res then
			break
		end
	end
	return res
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local chain=Duel.GetCurrentChain()
	if chkc then
		return chkc:IsLoc("OG") and s.tfil2(chkc,e,tp,eg,ep,ev,re,r,rp,chain-1) and chkc~=c
	end
	if chk==0 then
		return Duel.IETarget(s.tfil2,tp,"OG","OG",1,c,e,tp,eg,ep,ev,re,r,rp,chain)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,s.tfil2,tp,"OG","OG",1,1,c,e,tp,eg,ep,ev,re,r,rp,chain-1)
	local tc=g:GetFirst()
	local chk_e={}
	if tc:IsOnField() and c:IsFaceup() then
		for i=1,s[0] do
			local te=s[i]
			if tc:IsRelateToEffect(te) then
				table.insert(chk_e,te)
			end
		end
	end
	if tc:IsLoc("G") and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_COST) then
		local cre=c:GetReasonEffect()
		if cre and cre:GetHandler()==tc then
			table.insert(chk_e,cre)
		end
	end
	if s.act_g:IsContains(tc) then
		local i=0
		repeat
			local ae=tc.eff_ct[tc][i]
			if ae:IsHasType(EFFECT_TYPE_ACTIVATE) then
				table.insert(chk_e,ae)
			end
			i=i+1
		until not tc.eff_ct[tc][i]
	end
	chain=chain-1
	local sel_e={}
	for i=1,#chk_e do
		local te=chk_e[i]
		local tres,teg,tep,tev,tre,tr,trp
		if te:GetCode()==EVENT_CHAINING then
			local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local cc=ce:GetHandler()
			local cg=Group.FromCards(cc)
			local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
			teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
		elseif te:GetCode()==EVENT_FREE_CHAIN then
			teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
		else
			tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		end
		local res=(not con or con(e,tp,teg,tep,tev,tre,tr,trp)) and (not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0))
		if res then
			table.insert(sel_e,te)
		end
	end
	if #sel_e==0 then
		return
	end
	local off=1
	local ops={}
	local opval={}
	for i=1,#sel_e do
		local te=sel_e[i]
		ops[off]=te:GetDescription()
		opval[off-1]=te
		off=off+1
	end
	local ae
	if off==2 then
		ae=opval[0]
	else
		local op=Duel.SelectOption(tp,table.unpack(ops))
		ae=opval[op]
	end
	if ae:GetCode()==EVENT_CHAINING then
		local chain=Duel.GetCurrentChain()
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
	elseif ae:GetCode()==EVENT_FREE_CHAIN then
		teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
	else
		res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(ae:GetCode(),true)
	end
	Auxiliary.ChopinEtudeSetCode=0x2f3
	e:SetProperty(ae:GetProperty())
	if tg then
		tg(e,tp,teg,tep,tev,tre,tr,trp,1)
	end
	Duel.ClearOperationInfo(0)
	Auxiliary.ChopinEtudeSetCode=nil
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
	local le=c.eff_ct[c][0]
	le:SetLabelObject(ae)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then
		return
	end
	local le=c.eff_ct[c][0]
	local ae=le:GetLabelObject()
	local res,teg,tep,tev,tre,tr,trp
	if ae:GetCode()==EVENT_CHAINING then
		local chain=Duel.GetCurrentChain()
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
	elseif ae:GetCode()==EVENT_FREE_CHAIN then
		teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
	else
		res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(ae:GetCode(),true)
	end
	local op=ae:GetOperation()
	if op then
		Auxiliary.ChopinEtudeSetCode=0x2f3
		op(e,tp,teg,tep,tev,tre,tr,trp)
		Auxiliary.ChopinEtudeSetCode=nil
	end
end