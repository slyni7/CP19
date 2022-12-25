--하은하은☆나이트피버
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP+TYPE_COUNTER)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A","S")
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetSpellSpeed(3)
	e2:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"A","S")
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetSpellSpeed(3)
	e3:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e3,2,"C")
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetCL(1,{id,1})
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"STo")
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCL(1,{id,2})
	WriteEff(e5,5,"NTO")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"STo")
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCL(1,{id,2})
	WriteEff(e6,6,"NTO")
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"F")
	e7:SetCode(EFFECT_ACTIVATE_COST)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,1)
	e7:SetTarget(s.tar7)
	e7:SetOperation(s.op7)
	Duel.RegisterEffect(e7,0)
	if not s.global_check then
		s.global_check=true
		s[0]={}
		s[1]={}
		s[0][0]=false
		s[0][1]=false
		s[1][0]=false
		s[1][1]=false
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(s.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsCode(id) then
		if rc:IsSetCard("나이트피버") and re:IsActiveType(TYPE_MONSTER) then
			s[rp][0]=true
		elseif re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_COUNTER) then
			s[rp][1]=true
		end
	end
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	s[0][0]=false
	s[0][1]=false
	s[1][0]=false
	s[1][1]=false
end
function s.nfil2(c)
	return c:IsFaceup() and c:IsSetCard("나이트피버")
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetCurrentChain(true)==0 and Duel.IEMCard(s.nfil2,tp,"M",0,1,nil)
		and (not c:IsStatus(STATUS_SET_TURN) or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN))
		and c:IsFacedown()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1700)
	end
	Duel.PayLPCost(tp,1700)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ((re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
		or (re:IsActiveType(TYPE_MONSTER) and Duel.IEMCard(s.nfil2,tp,"M",0,1,nil)))
		and Duel.IsChainNegatable(ev)
		and (not c:IsStatus(STATUS_SET_TURN) or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN))
		and c:IsFacedown()
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsDestructable() then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local rc=re:GetHandler()
		if rc:IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
function s.tfil41(c,tp)
	local ft=Duel.GetLocCount(tp,"M")
	local g=c:GetColumnGroup()
	g:AddCard(c)
	return g:IsExists(Card.IsFacedown,1,nil) and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function s.tfil42(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard("나이트피버") and not c:IsCode(id)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and s.tfil41(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil41,tp,"O","O",1,nil,tp) and Duel.IEMCard(s.tfil42,tp,"D",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,s.tfil41,tp,"O","O",1,1,nil,tp)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 and Duel.GetLocCount(tp,"M")>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,s.tfil42,tp,"D",0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LSTN("M")) and s[tp][0]
end
function s.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsSSetable()
	end
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() and Duel.SSet(tp,c) then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function s.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LSTN("S")) and s[tp][1]
end
function s.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tar7(e,te,tp)
	local c=e:GetHandler()
	local tc=te:GetHandler()
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and c==tc
end
function s.op7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ChangePosition(c,POS_FACEUP)
	c:CancelToGrave(false)
end
