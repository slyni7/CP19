--쇼팽 에튀드 10-5 흑건
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		s[0]=0
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(s.gop2)
		Duel.RegisterEffect(ge2,0)		
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	s[0]=Duel.GetCurrentChain()
	s[Duel.GetCurrentChain()]={re,rp}
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	local v=s[0]
	for i=1,v do
		s[i]=nil
	end
end
function s.con1(e)
	local c=e:GetHandler()
	return c:IsPublic()
end
function s.tfil2(c)
	return c:IsSetCard(0x2f3) and c:IsFaceup()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=Duel.GMGroup(s.tfil2,tp,"O",0,nil)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsOnField()
	end
	if chk==0 then
		return #ct>0 and Duel.IETarget(aux.TRUE,tp,0,"O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,aux.TRUE,tp,0,"O",1,ct,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.ofil2(c,tlab,e,tp,eg,ep,ev,re,r,rp)
	local te=tlab[c]
	local con=te:GetCondition()
	local tg=te:GetTarget()
	local res,teg,tep,tev,tre,tr,trp
	if te:GetCode()==EVENT_CHAINING then
		local chain=Duel.GetCurrentChain()-1
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
	elseif te:GetCode()==EVENT_FREE_CHAIN then
		teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
	else
		res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
	end
	return (not con or con(e,tp,teg,tep,tev,tre,tr,trp))
		and (not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0))
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	local dg=Duel.GetTargetCards(e)
	if #dg==0 or Duel.Destroy(dg,REASON_EFFECT)==0 then
		return
	end
	local eset={}
	for i=1,s[0] do
		local te=s[i][1]
		local tep=s[i][2]
		local tc=te:GetHandler()
		if dg:IsContains(tc) then
			table.insert(eset,te)
		end
	end
	if #eset==0 then
		return
	end
	local tg=Group.CreateGroup()
	local tlab={}
	for i=1,#eset do
		local te=eset[i]
		local token=Duel.CreateToken(tp,te:GetHandler():GetOriginalCode())
		tg:AddCard(token)
		tlab[token]=te
	end
	local ug=Group.CreateGroup()
	while true do
		local sg=tg:Filter(s.ofil2,ug,tlab,e,tp,eg,ep,ev,re,r,rp)
		if #sg==0 then
			break
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local ag=sg:Select(tp,0,1,nil)
		if #ag==0 then
			break
		end
		local ac=ag:GetFirst()
		ug:AddCard(ac)
		local ae=tlab[ac]
		Duel.HintSelection(Group.FromCards(ae:GetHandler()))
		local tar=ae:GetTarget()
		local op=ae:GetOperation()
		e:SetProperty(ae:GetProperty())
		local res,teg,tep,tev,tre,tr,trp
		if te:GetCode()==EVENT_CHAINING then
			local chain=Duel.GetCurrentChain()-1
			local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local cc=ce:GetHandler()
			local cg=Group.FromCards(cc)
			local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
			teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
		elseif te:GetCode()==EVENT_FREE_CHAIN then
			teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
		else
			res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		end
		if tar then
			tar(e,tp,teg,tep,tev,tre,tr,trp,1)
		end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local etc=nil
		if g then
			etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op then
			op(e,tp,teg,tep,tev,tre,tr,trp)
		end
		if g then
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
		e:SetProperty(0)
	end
end