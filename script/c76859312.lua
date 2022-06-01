--넥서스 세리아
function c76859312.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76859312,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,76859312)
	e1:SetTarget(c76859312.tg1)
	e1:SetOperation(c76859312.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c76859312.cost2)
	e2:SetTarget(c76859312.tg2)
	e2:SetOperation(c76859312.op2)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c76859312.cost4)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76859312,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetCountLimit(1,76859313)
	e3:SetCondition(c76859312.con3)
	e3:SetCost(c76859312.cost3)
	e3:SetTarget(c76859312.tg3)
	e3:SetOperation(c76859312.op3)
	c:RegisterEffect(e3)
end
function c76859312.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsPlayerCanDiscardDeck(tp,1)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c76859312.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then
		return
	end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc:IsSetCard(0x2c5) or tc:IsType(TYPE_TRAP) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetDescription(aux.Stringid(76859312,0))
			e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END,2)
			e1:SetCost(c76859312.cost11)
			e1:SetTarget(c76859312.tar11)
			e1:SetOperation(c76859312.op11)
			tc:RegisterEffect(e1)
			local e3=e1:Clone()
			e3:SetCode(EVENT_SUMMON)
			tc:RegisterEffect(e3)
			local e4=e1:Clone()
			e4:SetCode(EVENT_SPSUMMON)
			tc:RegisterEffect(e4)
			local e5=e1:Clone()
			e5:SetCode(EVENT_FLIP_SUMMON)
			tc:RegisterEffect(e5)
		end
	else
		Duel.MoveSequence(tc,1)
	end
end
function c76859312.cost11(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(76859312)<1
	end
	c:RegisterFlagEffect(76859312,RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END,0,2)
end
function c76859312.tar11(e,tp,eg,ep,ev,re,r,rp,chk)
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
			elseif event>=EVENT_SUMMON and event<=EVENT_SPSUMMON then
				if te:GetCode()==event then
					if (not con or con(te,tp,eg,ep,ev,re,r,rp))
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
						and (not tg or tg(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp,0)) then
						res=true
						break
					end
				end
			elseif te:GetCode()==EVENT_FREE_CHAIN then
				if (not con or con(te,tp,eg,ep,ev,re,r,rp))
					and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
					res=true
					break
				end
			else
				local tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
				if tres
					and (not con or con(te,tp,teg,tep,tev,tre,tr,trp))
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
		elseif event>=EVENT_SUMMON and event<=EVENT_SPSUMMON then
			if te:GetCode()==event then
				if Duel.GetCurrentChain()==1 then
					aux.CheckDisSumAble=true
				end
				if (not con or con(te,tp,eg,ep,ev,re,r,rp))
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
function c76859312.op11(e,tp,eg,ep,ev,re,r,rp)
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
function c76859312.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost() and not Duel.IsPlayerAffectedByEffect(tp,76859317)
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function c76859312.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost() and Duel.IsPlayerAffectedByEffect(tp,76859317)
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function c76859312.tfilter2(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_TRAP) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSSetable()
end
function c76859312.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return c76859312.tfilter2(chkc)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c76859312.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c76859312.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
end
function c76859312.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then
		return
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then
		return
	end
	Duel.SSet(tp,tc)
end
function c76859312.con3(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e)
end
function c76859312.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c76859312.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDiscardDeck(tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c76859312.op3(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then
		return
	end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x2c5) or tc:IsType(TYPE_TRAP) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		if tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetDescription(aux.Stringid(76859312,0))
			e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END,2)
			e1:SetCost(c76859312.cost11)
			e1:SetTarget(c76859312.tar11)
			e1:SetOperation(c76859312.op11)
			tc:RegisterEffect(e1)
			local e3=e1:Clone()
			e3:SetCode(EVENT_SUMMON)
			tc:RegisterEffect(e3)
			local e4=e1:Clone()
			e4:SetCode(EVENT_SPSUMMON)
			tc:RegisterEffect(e4)
			local e5=e1:Clone()
			e5:SetCode(EVENT_FLIP_SUMMON)
			tc:RegisterEffect(e5)
		end
	else
		Duel.MoveSequence(tc,1)
	end
end