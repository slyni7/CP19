--넥서스 에밀리아
function c76859301.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(c76859301.cost1)
	e1:SetTarget(c76859301.tg1)
	e1:SetOperation(c76859301.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e3:SetCost(c76859301.cost1)
	e3:SetTarget(c76859301.tg1)
	e3:SetOperation(c76859301.op1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCondition(c76859301.con4)
	e4:SetCost(c76859301.cost4)
	e4:SetTarget(c76859301.tg4)
	e4:SetOperation(c76859301.op4)
	c:RegisterEffect(e4)
	local e6=e4:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCost(c76859301.cost6)
	c:RegisterEffect(e6)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCategory(CATEGORY_DECKDES)
	e5:SetCost(c76859301.cost5)
	e5:SetTarget(c76859301.tg5)
	e5:SetOperation(c76859301.op5)
	c:RegisterEffect(e5)
end
function c76859301.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(76859401)<1
	end
	c:RegisterFlagEffect(76859401,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
end
function c76859301.tfilter1(c)
	return (c:IsSetCard(0x2c5) or c:IsType(TYPE_TRAP)) and c:IsAbleToGrave()
end
function c76859301.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859301.tfilter1,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c76859301.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c76859301.tfilter1,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		if Duel.Draw(tp,2,REASON_EFFECT) then
			local c=e:GetHandler()
			if c:IsRelateToEffect(e) then
				c:RegisterFlagEffect(76859301,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
end
function c76859301.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(76859301)>0
end
function c76859301.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
			and (Duel.GetFlagEffect(tp,76859301)+Duel.GetFlagEffect(tp,76859351)==0
				and not Duel.IsPlayerAffectedByEffect(tp,76859317))
	end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.RegisterFlagEffect(tp,76859301,RESET_PHASE+PHASE_END,0,1)
end
function c76859301.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
			and Duel.IsPlayerAffectedByEffect(tp,76859317)
	end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.RegisterFlagEffect(tp,76859301,RESET_PHASE+PHASE_END,0,1)
end
function c76859301.tfilter4(c,e,tp)
	return c:IsSetCard(0x2c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(76859301)
end
function c76859301.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859301.tfilter4,tp,LOCATION_DECK,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859301.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76859301.tfilter4,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c76859301.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
			and ((Duel.GetFlagEffect(tp,76859301)==0 or Duel.IsPlayerAffectedByEffect(tp,76859317))
				and Duel.GetFlagEffect(tp,76859351)==0)
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,76859351,RESET_PHASE+PHASE_END,0,1)
end
function c76859301.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDiscardDeck(tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c76859301.op5(e,tp,eg,ep,ev,re,r,rp)
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
			e1:SetDescription(aux.Stringid(76859301,0))
			e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END,2)
			e1:SetCost(c76859301.cost51)
			e1:SetTarget(c76859301.tar51)
			e1:SetOperation(c76859301.op51)
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
function c76859301.cost51(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(76859301)<1
	end
	c:RegisterFlagEffect(76859301,RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END,0,2)
end
function c76859301.tar51(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c76859301.op51(e,tp,eg,ep,ev,re,r,rp)
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