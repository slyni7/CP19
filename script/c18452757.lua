--울고 싶어질 때도 미소짓게 만드는 마법
local m=18452757
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,"DG")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(cm.ocon11)
	e1:SetOperation(cm.oop11)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FTf","DG")
	e2:SetCode(m)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.ocon12)
	e2:SetCost(cm.ocost12)
	e2:SetTarget(cm.otar12)
	e2:SetOperation(cm.oop12)
	local e3=MakeEff(c,"FG")
	e3:SetTR("DG",0)
	e3:SetLabelObject(e2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTarget(cm.otar13)
	Duel.RegisterEffect(e3,tp)
	local e4=MakeEff(c,"F","DG")
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCost(cm.ocost14)
	e4:SetTarget(cm.otar14)
	e4:SetOperation(cm.oop14)
	local e5=MakeEff(c,"FG")
	e5:SetTR("DG",0)
	e5:SetLabelObject(e4)
	e5:SetReset(RESET_PHASE+PHASE_END)
	e5:SetTarget(cm.otar13)
	Duel.RegisterEffect(e5,tp)
end
function cm.onfil11(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x2d3)
end
function cm.ocon11(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.onfil11,1,nil,tp)
end
function cm.oofil111(c,tp,typ)
	return c:IsControler(tp) and c:IsSetCard(0x2d3) and not c:IsType(typ)
end
function cm.oofil112(c,e,tp)
	return c:IsSetCard(0x2d4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.oofil113(c)
	return c:IsSetCard("바이러스") and c:IsSSetable()
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	if not e or not tp or not eg then
		return
	end
	if eg:IsExists(cm.oofil111,1,nil,tp,TYPE_MONSTER) and Duel.GetFlagEffect(tp,m)<1 then
		local mg=Duel.GMGroup(cm.oofil112,tp,"DG",0,nil,e,tp)
		if #mg>0 and Duel.GetLocCount(tp,"M")>0 then
			Duel.Hint(HINT_CARD,0,m)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local og=mg:Select(tp,1,1,nil)
			Duel.SpecialSummon(og,0,tp,tp,false,false,POS_FACEUP)
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		end
	end	
	if eg:IsExists(cm.oofil111,1,nil,tp,TYPE_SPELL) and Duel.GetFlagEffect(tp,m+1)<1 then
		Duel.RaiseEvent(eg,m,e,0,tp,tp,0)
	end
	if eg:IsExists(cm.oofil111,1,nil,tp,TYPE_TRAP) and Duel.GetFlagEffect(tp,m+2)<1 then
		local tg=Duel.GMGroup(cm.oofil113,tp,"DG",0,nil)
		if #tg>0 and Duel.GetLocCount(tp,"S")>0 then
			Duel.Hint(HINT_CARD,0,m)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local og=tg:Select(tp,1,1,nil)
			Duel.SSet(tp,og)
			Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function cm.ocon12(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function cm.ocost12(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m+1)<1
	end
	Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
end
function cm.otar12(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()

	if chk==0 then
		local res=false
		local chain=Duel.GetCurrentChain()
		local event=e:GetCode()
		local i=0
		repeat
			local te=c.eff_ct[c][i]
			local con=te:GetCondition()
			local co=te:GetCost()
			local tg=te:GetTarget()
			if not te:IsHasType(EFFECT_TYPE_ACTIVATE) then
			elseif not te:CheckCountLimit(tp) then
			elseif event>=EVENT_SUMMON and event<=EVENT_SPSUMMON then
				if te:GetCode()==event then
					if (not con or con(te,tp,eg,ep,ev,re,r,rp))
						and (not co or co(te,tp,eg,ep,ev,re,r,rp,0))
						and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
						res=true
					end
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
	local off=1
	local ops={}
	local opval={}
	local chain=Duel.GetCurrentChain()-1
	local event=e:GetCode()
	local i=0
	repeat
		local te=c.eff_ct[c][i]
		local res=false
		local con=te:GetCondition()
		local co=te:GetCost()
		local tg=te:GetTarget()
		if not te:IsHasType(EFFECT_TYPE_ACTIVATE) then
		elseif not te:CheckCountLimit(tp) then
		elseif event>=EVENT_SUMMON and event<=EVENT_SPSUMMON then
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
	until not c.eff_ct[c][i]
	local ae=nil
	if off==2 then
		ae=opval[0]
	else
		local op=Duel.SelectOption(tp,table.unpack(ops))
		ae=opval[op]
	end
	e:SetCategory(ae:GetCategory())
	e:SetProperty(ae:GetProperty())
	e:SetType(EFFECT_TYPE_ACTIVATE)
	ae:UseCountLimit(tp,1,true)
	local co=ae:GetCost()
	local tg=ae:GetTarget()
	if ae:GetCode()==EVENT_CHAINING then
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		if co then
			co(e,tp,cg,cp,chain,ce,REASON_EFFECT,cp,1)
		end
		if tg then
			tg(e,tp,cg,cp,chain,ce,REASON_EFFECT,cp,1)
		end
	elseif ae:GetCode()==EVENT_FREE_CHAIN then
		if co then
			co(e,tp,eg,ep,ev,re,r,rp,1)
		end
		if tg then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(ae:GetCode(),true)
		if co then
			co(e,tp,teg,tep,tev,tre,tr,trp,1)
		end
		if tg then
			tg(e,tp,teg,tep,tev,tre,tr,trp,1)
		end
	end
	ae:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(ae)	
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
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
function cm.otar13(e,c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x2d3)
end
function cm.ocost14(e,te,tp)
	local c=e:GetHandler()
	if bit.band(c:GetType(),TYPE_FIELD)>0 then
		return true
	else
		return Duel.GetLocCount(tp,"S")>0
	end
end
function cm.otar14(e,te,tp)
	local c=e:GetHandler()
	local tc=te:GetHandler()
	return te:GetCode()==m and c==tc
end
function cm.oop14(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetType(),TYPE_FIELD)>0 then
		Duel.MoveToField(c,tp,tp,LSTN("F"),POS_FACEUP,true)
	else
		Duel.MoveToField(c,tp,tp,LSTN("S"),POS_FACEUP,true)
	end
end