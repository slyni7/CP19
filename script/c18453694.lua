--유령의 눈보라
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		s[0]=true
		s[1]=true
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
	s[rp]=false
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	s[0]=true
	s[1]=true
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.CheckLPCost(tp,1800) or not c:IsLoc("H")
	end
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.PayLPCost(tp,1800)
	end
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLoc("M") and chkc:IsControler(1-tp) and chkc:IsNegatableMonster()
	end
	local cc=Duel.GetCurrentChain()
	local ce=nil
	if cc>0 then
		ce=Duel.GetChainInfo(cc,CHAININFO_TRIGGERING_EFFECT)
	end
	local b1=Duel.IETarget(Card.IsNegatableMonster,tp,0,"M",1,nil)
	local b2=ce and ce:GetHandler():IsOnField() and (ce:IsActiveType(TYPE_MONSTER)
		or (ce:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not ce:IsHasType(EFFECT_TYPE_ACTIVATE)))
	if chk==0 then
		return b1 or b2
	end
	if cc>1 then
		ce=Duel.GetChainInfo(cc-1,CHAININFO_TRIGGERING_EFFECT)
	end
	b2=ce and ce:GetHandler():IsOnField() and (ce:IsActiveType(TYPE_MONSTER)
		or (ce:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not ce:IsHasType(EFFECT_TYPE_ACTIVATE)))
	local min=1
	if b2 then
		min=0
	end
	local b3=not c:IsStatus(STATUS_ACT_FROM_HAND) or s[tp]
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,Card.IsNegatableMonster,tp,0,"M",min,1,nil)
	if #g>0 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.SOI(0,CATEGORY_DISABLE,g,1,0,0)
		if b2 and b3 then
			e:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
			Duel.SOI(0,CATEGORY_DESTROY,ce:GetHandler(),1,0,0)
		else
			e:SetCategory(CATEGORY_DISABLE)
		end
	else
		e:SetProperty(0)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SOI(0,CATEGORY_DESTROY,ce:GetHandler(),1,0,0)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsMonster() and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
	local cc=Duel.GetCurrentChain()
	local ce=nil
	if cc>1 then
		ce=Duel.GetChainInfo(cc-1,CHAININFO_TRIGGERING_EFFECT)
	end
	local b2=ce and ce:GetHandler():IsOnField() and (ce:IsActiveType(TYPE_MONSTER)
		or (ce:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not ce:IsHasType(EFFECT_TYPE_ACTIVATE)))
		and ce:GetHandler():IsRelateToEffect(ce)
	local b3=not c:IsStatus(STATUS_ACT_FROM_HAND) or s[tp]
	if (not tc or (b3 and Duel.SelectYesNo(tp,aux.Stringid(id,0)))) and b2 then
		Duel.Destroy(ce:GetHandler(),REASON_EFFECT)
	end
end