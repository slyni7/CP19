--쇼팽 에튀드 10-9 밤여행
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DRAW)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
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
	if chkc then
		return chkc~=c and chkc:IsControler(tp) and chkc:IsOnField() and s.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil2,tp,"O",0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.STarget(tp,s.tfil2,tp,"O",0,1,1,c)
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then
		return
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(s.oval21)
	tc:RegisterEffect(e1)
	local cc=Duel.GetCurrentChain()
	if cc<2 then
		return
	end
	local ce=Duel.GetChaininfo(cc-1,CHAININFO_TRIGGERING_EFFECT)
	local rc=ce:GetHandler()
	local con=ce:GetCondition()
	local tg=ce:GetTarget()
	Auxiliary.ChopinEtudeSetCode=0x2f3
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
	res=(not con or con(e,tp,teg,tep,tev,tre,tr,trp)) and (not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0))
	Auxiliary.ChopinEtudeSetCode=nil
	if res and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local op=ce:GetOperation()
		e:SetProperty(re:GetProperty())
		if tg then
			Auxiliary.ChopinEtudeSetCode=0x2f3
			tg(e,tp,teg,tep,tev,tre,tr,trp,1)
			Auxiliary.ChopinEtudeSetCode=nil
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
			Auxiliary.ChopinEtudeSetCode=0x2f3
			op(e,tp,teg,tep,tev,tre,tr,trp)
			Auxiliary.ChopinEtudeSetCode=nil
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
function s.oval21(e,te)
	return e:GetOwnerPlayer()~=te:GetHandlerPlayer()
end