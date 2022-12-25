--약식기소
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_CHAINING)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"A")
	e3:SetCode(EVENT_CHAINING)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	WriteEff(e3,2,"CT")
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"A")
	e4:SetCode(EVENT_SUMMON)
	e4:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_DRAW)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
end

function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a and a:IsControler(1-tp)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if chk==0 then
		return Duel.IsPlayerCanDraw(1-tp,1)
	end
	if a:IsRelateToBattle() then
		Duel.SOI(0,CATEGORY_DESTROY,a,1,0,0)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() and a:IsRelateToBattle() and Duel.Destroy(a,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		if Duel.Draw(1-tp,1,REASON_EFFECT)==0 then
			return
		end
		if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()>PHASE_MAIN1 and Duel.GetCurrentPhase()<PHASE_MAIN2 then
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		end
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return rp~=tp and rc:GetType()==TYPE_SPELL and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1000)
	end
	Duel.PayLPCost(tp,1000)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(1-tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			if Duel.Draw(1-tp,1,REASON_EFFECT)==0 then
				return
			end
			local ph=Duel.GetCurrentPhase()
			if Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or PHASE_MAIN2) then
				Duel.SkipPhase(1-tp,ph,RESET_PHASE+ph,1)
			end
		end
	end
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return rp~=tp and rc:GetType()==TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.GetTurnPlayer()==tp and ph>=PHASE_MAIN1 and ph<PHASE_MAIN2
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			if Duel.Draw(1-tp,1,REASON_EFFECT)==0 then
				return
			end
			local ph=Duel.GetCurrentPhase()
			if Duel.GetTurnPlayer()==tp and ph>=PHASE_MAIN1 and ph<PHASE_MAIN2 then
				local e1=MakeEff(c,"F")
				e1:SetCode(EFFECT_BP_TWICE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTR(1,0)
				e1:SetValue(1)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return rp~=tp and Duel.GetCurrentChain(true)==0 and Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,2000)
	end
	Duel.PayLPCost(tp,2000)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(1-tp,1)
	end
	Duel.SOI(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SOI(0,CATEGORY_REMOVE,eg,#eg,0,0)
	Duel.SOI(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	Duel.BreakEffect()
	if Duel.Draw(1-tp,1,REASON_EFFECT)>0 then
		local ph=Duel.GetCurrentPhase()
		if Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or PHASE_MAIN2) then
			Duel.SkipPhase(1-tp,ph,RESET_PHASE+ph,1)
		end
	end
end