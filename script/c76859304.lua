--넥서스 줄리아
function c76859304.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_TUNER),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCost(c76859304.cost1)
	e1:SetOperation(c76859304.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCost(c76859304.cost1)
	e2:SetOperation(c76859304.op1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76859304,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c76859304.con3)
	e3:SetCost(c76859304.cost3)
	e3:SetTarget(c76859304.tg3)
	e3:SetOperation(c76859304.op3)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCost(c76859304.cost5)
	c:RegisterEffect(e5)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCost(c76859304.cost4)
	e4:SetTarget(c76859304.tg3)
	e4:SetOperation(c76859304.op4)
	c:RegisterEffect(e4)
end
function c76859304.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetFlagEffect(76859404)<1
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	c:RegisterFlagEffect(76859404,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
end
function c76859304.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(76859304,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76859304,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c76859304.con11)
	e1:SetOperation(c76859304.op11)
	Duel.RegisterEffect(e1,tp)
end
function c76859304.nfilter11(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x2c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76859304.con11(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c76859304.nfilter11,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c76859304.op11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,76859304)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76859304.nfilter11,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c76859304.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(76859304)>0
end
function c76859304.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
			and (Duel.GetFlagEffect(tp,76859304)+Duel.GetFlagEffect(tp,76859354)==0
				and not Duel.IsPlayerAffectedByEffect(tp,76859317))
	end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.RegisterFlagEffect(tp,76859304,RESET_PHASE+PHASE_END,0,1)
end
function c76859304.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
			and Duel.IsPlayerAffectedByEffect(tp,76859317)
	end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.RegisterFlagEffect(tp,76859304,RESET_PHASE+PHASE_END,0,1)
end
function c76859304.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDiscardDeck(tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c76859304.op3(e,tp,eg,ep,ev,re,r,rp)
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
			e1:SetDescription(aux.Stringid(76859304,2))
			e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END,2)
			e1:SetCost(c76859304.cost31)
			e1:SetTarget(c76859304.tar31)
			e1:SetOperation(c76859304.op31)
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
function c76859304.cost31(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(76859304)<1
	end
	c:RegisterFlagEffect(76859304,RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END,0,2)
end
function c76859304.tar31(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c76859304.op31(e,tp,eg,ep,ev,re,r,rp)
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
function c76859304.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
			and ((Duel.GetFlagEffect(tp,76859304)==0 or Duel.IsPlayerAffectedByEffect(tp,76859317))
				and Duel.GetFlagEffect(tp,76859354)==0)
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,76859354,RESET_PHASE+PHASE_END,0,1)
end
function c76859304.op4(e,tp,eg,ep,ev,re,r,rp)
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
			e1:SetDescription(aux.Stringid(76859304,2))
			e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END,2)
			e1:SetCost(c76859304.cost31)
			e1:SetTarget(c76859304.tar31)
			e1:SetOperation(c76859304.op31)
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
		if tc:IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		else
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)			
		end
	end
end