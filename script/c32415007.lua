--영원한 건 없어
local m=32415007
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON)
	WriteEff(e2,2,"N")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
end
function cm.tfil1(c,tp,eg,ep,ev,re,r,rp,tc,chain,event)
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if tc and tc:IsLocation(LOCATION_HAND) then
		ct=ct-1
	end
	if c:IsCode(m) or not c:IsType(TYPE_COUNTER) or ct<1 or not c.eff_ct[c][0] then
		return false
	end
	local i=0
	local res=false
	repeat
		local te=c.eff_ct[c][i]
		local con=te:GetCondition()
		local co=te:GetCost()
		local tg=te:GetTarget()
		if not te:IsHasType(EFFECT_TYPE_ACTIVATE) then
		elseif event>=EVENT_SUMMON and event<=EVENT_SPSUMMON then
			if te:GetCode()==event then
				if Duel.GetCurrentChain()==1 and chain<1 then
					aux.CheckDisSumAble=true
				end
				if (not con or con(te,tp,eg,ep,ev,re,r,rp))
					and (not co or co(te,tp,eg,ep,ev,re,r,rp,0))
					and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
					res=true
				end
				aux.CheckDisSumAble=false
				if res then
					break
				end
			end
		elseif te:GetCode()==EVENT_CHAINING then
			if chain>0 then
				local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
				local cc=ce:GetHandler()
				local cg=Group.FromCards(cc)
				local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
				if (not con or con(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp))
					and (not co or co(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp,0))
					and (not tg or tg(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp,0)) then
					res=true
					break
				end
			end
		elseif te:GetCode()==EVENT_FREE_CHAIN then
			if (not con or con(te,tp,eg,ep,ev,re,r,rp))
				and (not co or co(te,tp,eg,ep,ev,re,r,rp,0))
				and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
				res=true
				break
			end
		else
			local tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
			if tres
				and (not con or con(te,tp,teg,tep,tev,tre,tr,trp))
				and (not co or co(te,tp,teg,tep,tev,tre,tr,trp,0))
				and (not tg or tg(te,tp,teg,tep,tev,tre,tr,trp,0)) then
				res=true
				break
			end
		end
		i=i+1
	until not c.eff_ct[c][i]
	return res
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local chain=Duel.GetCurrentChain()
	local event=e:GetCode()
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil,tp,eg,ep,ev,re,r,rp,c,chain,event)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chain=Duel.GetCurrentChain()-1
	local event=e:GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local ag=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil,tp,eg,ep,ev,re,r,rp,c,chain,event)
	local tc=ag:GetFirst()
	if not tc then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/300)*100)
		return
	end
	if not tc.eff_ct[tc][0] then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/300)*100)
		return
	end
	local off=1
	local ops={}
	local opval={}
	local i=0
	repeat
		local te=tc.eff_ct[tc][i]
		local res=false
		local con=te:GetCondition()
		local co=te:GetCost()
		local tg=te:GetTarget()
		if event>=EVENT_SUMMON and event<=EVENT_SPSUMMON then
			if te:GetCode()==event then
				if Duel.GetCurrentChain()==1 then
					aux.CheckDisSumAble=true
				end
				if (not con or con(te,tp,eg,ep,ev,re,r,rp))
					and (not co or co(te,tp,eg,ep,ev,re,r,rp,0))
					and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
					res=true
				end
				aux.CheckDisSumAble=false
			end
		elseif te:GetCode()==EVENT_CHAINING then
			if chain>0 then
				local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
				local cc=ce:GetHandler()
				local cg=Group.FromCards(cc)
				local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
				if (not con or con(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp))
					and (not co or co(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp,0))
					and (not tg or tg(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp,0)) then
					res=true
				end
			end
		elseif te:GetCode()==EVENT_FREE_CHAIN then
			if (not con or con(te,tp,eg,ep,ev,re,r,rp))
				and (not co or co(te,tp,eg,ep,ev,re,r,rp,0))
				and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
				res=true
			end
		else
			local tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
			if tres
				and (not con or con(te,tp,teg,tep,tev,tre,tr,trp))
				and (not co or co(te,tp,teg,tep,tev,tre,tr,trp,0))
				and (not tg or tg(te,tp,teg,tep,tev,tre,tr,trp,0)) then
				res=true
			end
		end
		if res then
			ops[off]=te:GetDescription()
			opval[off-1]=te
			off=off+1
		end
		i=i+1
	until not tc.eff_ct[tc][i]
	if off==1 then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/300)*100)
		return
	end
	local ae=nil
	if off==2 then
		ae=opval[0]
	else
		local op=Duel.SelectOption(tp,table.unpack(ops))
		ae=opval[op]
	end
	local tpe=tc:GetType()
	local co=ae:GetCost()
	local tg=ae:GetTarget()
	local op=ae:GetOperation()
	e:SetCategory(ae:GetCategory())
	e:SetProperty(ae:GetProperty())
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.HintActivation(ae)
	e:SetActiveEffect(ae)
	if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)<1 then
		tc:CancelToGrave(false)
	end
	tc:CreateEffectRelation(ae)
	if ae:GetCode()==EVENT_CHAINING then
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		if co then
			co(ae,tp,cg,cp,chain,ce,REASON_EFFECT,cp,1)
		end
		if tg then
			tg(ae,tp,cg,cp,chain,ce,REASON_EFFECT,cp,1)
		end
	elseif ae:GetCode()==EVENT_FREE_CHAIN then
		if co then
			co(ae,tp,eg,ep,ev,re,r,rp,1)
		end
		if tg then
			tg(ae,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(ae:GetCode(),true)
		if co then
			co(ae,tp,teg,tep,tev,tre,tr,trp,1)
		end
		if tg then
			tg(ae,tp,teg,tep,tev,tre,tr,trp,1)
		end
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g then
		local etc=g:GetFirst()
		while etc do
			etc:CreateEffectRelation(ae)
			etc=g:GetNext()
		end
	end
	Duel.BreakEffect()
	if ae:GetCode()==EVENT_CHAINING then
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		if op then
			op(ae,tp,cg,cp,chain,ce,REASON_EFFECT,cp)
		end
	elseif ae:GetCode()==EVENT_FREE_CHAIN then
		if op then
			op(ae,tp,eg,ep,ev,re,r,rp)
		end
	else
		local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(ae:GetCode(),true)
		if op then
			op(ae,tp,teg,tep,tev,tre,tr,trp)
		end
	end
	if g then
		local etc=g:GetFirst()
		while etc do
			etc:ReleaseEffectRelation(ae)
			etc=g:GetNext()
		end
	end
	e:SetActiveEffect(nil)
	e:SetCategory(0)
	e:SetProperty(0)
	Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/300)*100)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()<1
end