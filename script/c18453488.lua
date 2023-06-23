--망조의 지명자
local m=18453488
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_CHAIN_END)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		cm[0]={}
		cm[1]={}
		cm.current_chain={}
		cm.remain_effect={}
		local cregeff=Card.RegisterEffect
		function Card.RegisterEffect(c,e,forced,...)
			cregeff(c,e,forced,...)
			local cc=Duel.GetCurrentChain()
			if cc>0 then
				local c0=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
				local ce=Duel.GetChainInfo(cc,CHAININFO_TRIGGERING_EFFECT)
				if c0==ce then
					--not fully implemented
				end
			end
		end
		local dregeff=Duel.RegisterEffect
		function Duel.RegisterEffect(e,p,...)
			dregeff(e,p,...)
			local cc=Duel.GetCurrentChain()
			if cc>0 then
				local c0=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
				local ce=Duel.GetChainInfo(cc,CHAININFO_TRIGGERING_EFFECT)
				if c0==ce then
					table.insert(cm.current_chain,e)
				end
			end
		end
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	cm.current_chain={}
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	if #cm.current_chain>0 then
		if cm[0][Duel.GetTurnCount()]==nil then
			cm[0][Duel.GetTurnCount()]=Group.CreateGroup()
			cm[0][Duel.GetTurnCount()]:KeepAlive()
			cm[1][Duel.GetTurnCount()]=Group.CreateGroup()
			cm[1][Duel.GetTurnCount()]:KeepAlive()
		end
		local token0=Duel.CreateToken(0,re:GetHandler():GetOriginalCode())
		cm[0][Duel.GetTurnCount()]:AddCard(token0)
		local token1=Duel.CreateToken(1,re:GetHandler():GetOriginalCode())
		cm[1][Duel.GetTurnCount()]:AddCard(token1)
		cm.remain_effect[token0]={token1,table.unpack(cm.current_chain)}
		cm.remain_effect[token1]={token0,table.unpack(cm.current_chain)}
	end
end
function cm.tfil1(c)
	return cm.remain_effect[c]
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=0
	local g=cm[tp][Duel.GetTurnCount()]
	if chk==0 then
		return g and g:IsExists(cm.tfil1,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:FilterSelect(tp,cm.tfil1,1,1,nil)
	Duel.ConfirmCards(1-tp,sg)
	local tc=sg:GetFirst()
	e:SetLabelObject(tc)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if cm.remain_effect[tc] then
		local oc=cm.remain_effect[tc][1]
		for i=2,#cm.remain_effect[tc] do
			local te=cm.remain_effect[tc][i]
			te:Reset()
		end
		cm.remain_effect[tc]=nil
		cm.remain_effect[oc]=nil
	end
end