--쇼팽 에튀드 25-12 대양
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","F")
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetTR("H",0)
	e2:SetTarget(s.tar2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","F")
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTR("M",0)
	e3:SetValue(500)
	e3:SetTarget(s.tar3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"Qo","F")
	e5:SetCode(EVENT_CHAINING)
	e5:SetCategory(CATEGORY_DRAW)
	WriteEff(e5,5,"NCTO")
	c:RegisterEffect(e5)
end
function s.ofil1(c)
	return c:IsSetCard(0x2f3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local ct=Duel.GetTurnCount()
		if Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SMCard(tp,s.ofil1,tp,"D",0,0,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function s.tar2(e,c)
	local r=c:GetReason()
	if r&REASON_EFFECT==0 then
		return false
	end
	local re=c:GetReasonEffect()
	if not re then
		return false
	end
	local rc=re:GetHandler()
	if not rc:IsSetCard(0x2f3) then
		return false
	end
	local tid=c:GetTurnID()
	if Duel.GetTurnCount()~=tid then
		return false
	end
	return true
end
function s.tar3(e,c)
	return c:IsRace(RACE_INSECT) or c:IsAttribute(ATTRIBUTE_WATER)
end
function s.con5(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function s.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	local con=re:GetCondition()
	local tg=re:GetTarget()
	Auxiliary.ChopinEtudeSetCode=0x2f3
	local res,teg,tep,tev,tre,tr,trp
	if re:GetCode()==EVENT_CHAINING then
		local chain=Duel.GetCurrentChain()
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
	elseif re:GetCode()==EVENT_FREE_CHAIN then
		teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
	else
		res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(re:GetCode(),true)
	end
	res=(not con or con(e,tp,teg,tep,tev,tre,tr,trp)) and (not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0))
	Auxiliary.ChopinEtudeSetCode=nil
	if chk==0 then
		e:SetProperty(0)
		return res
	end
	if re:GetCode()==EVENT_CHAINING then
		local chain=Duel.GetCurrentChain()
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
	elseif re:GetCode()==EVENT_FREE_CHAIN then
		teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
	else
		res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(re:GetCode(),true)
	end
	Auxiliary.ChopinEtudeSetCode=0x2f3
	e:SetProperty(re:GetProperty())
	if tg then
		tg(e,tp,teg,tep,tev,tre,tr,trp,1)
	end
	Duel.ClearOperationInfo(0)
	Auxiliary.ChopinEtudeSetCode=nil
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	local res,teg,tep,tev,tre,tr,trp
	if re:GetCode()==EVENT_CHAINING then
		local chain=Duel.GetCurrentChain()
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
	elseif re:GetCode()==EVENT_FREE_CHAIN then
		teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
	else
		res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(re:GetCode(),true)
	end
	local op=re:GetOperation()
	if op then
		Auxiliary.ChopinEtudeSetCode=0x2f3
		op(e,tp,teg,tep,tev,tre,tr,trp)
		Auxiliary.ChopinEtudeSetCode=nil
	end
end