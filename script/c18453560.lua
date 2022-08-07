--쇼팽 에튀드 25-9 나비
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetTR("H",0)
	e1:SetTarget(s.tar1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","H")
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SEARCH)
	e2:SetCL(1,id)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","G")
	e3:SetCode(EVENT_CHAINING)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e3:SetCL(1,{id,1})
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
function s.tar1(e,c)
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
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.tfil2(c)
	return c:IsCode(18453563) and c:IsAbleToHand()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
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
	end
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
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
		local chain=Duel.GetCurrentChain()-1
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
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	local c=e:GetHandler()
	local res,teg,tep,tev,tre,tr,trp
	if re:GetCode()==EVENT_CHAINING then
		local chain=Duel.GetCurrentChain()-1
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
	if c:IsRelateToEffect(e) and Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end