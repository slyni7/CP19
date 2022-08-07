--쇼팽 에튀드 10-1 승리
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_CHAINING)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
end
function s.con1(e)
	local c=e:GetHandler()
	return c:IsPublic()
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and rp~=tp
end
function s.cfil2(c)
	return c:IsSetCard(0x2f3) and c:IsPublic()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.cfil2,tp,"H",0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SMCard(tp,s.cfil2,tp,"H",0,1,1,c)
	local tc=g:GetFirst()
	aux.RegisterUnpublic(e,tc)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsDestructable() then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and Duel.Destroy(rc,REASON_EFFECT)>0 then
		local con=re:GetCondition()
		local tg=re:GetTarget()
		Auxiliary.ChopinEtudeSetCode=0x2f3
		local res=(not con or con(e,tp,eg,ep,ev,re,r,rp)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0))
		Auxiliary.ChopinEtudeSetCode=nil
		if res and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local op=re:GetOperation()
			e:SetProperty(re:GetProperty())
			if tg then
				Auxiliary.ChopinEtudeSetCode=0x2f3
				tg(e,tp,eg,ep,ev,re,r,rp,1)
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
				op(e,tp,eg,ep,ev,re,r,rp)
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
end