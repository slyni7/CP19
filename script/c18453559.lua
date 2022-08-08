--쇼팽 에튀드 25-7 첼로
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","S")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RECOVER+CATEGORY_DRAW)
	e2:SetCL(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetD(id,0)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","S")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e3:SetCL(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetD(id,1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","S")
	e4:SetCode(EVENT_CHAINING)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetCL(1,{id,1})
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local ct=Duel.GetTurnCount()
		Duel.FractionDraw(tp,{ct,3},REASON_EFFECT)
	end
end
function s.tfil2(c)
	return c:IsSetCard(0x12f3) and c:IsAbleToHand()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,2500)
	end
	Duel.PayLPCost(tp,2500)
end
function s.tfil3(c)
	return c:IsSetCard(0x22f3) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function s.cfil4(c)
	return c:IsSetCard(0x2f3) and c:IsAbleToGraveAsCost()
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.cfil4,tp,"HO",0,1,nil)
	end
	Duel.Hint(HINT_SELEECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.cfil4,tp,"HO",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=g:GetFirst()
	if tc==c then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
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
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 and not c:IsRelateToEffect(e) then
		return
	end
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