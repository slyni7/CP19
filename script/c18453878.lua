--신천지의 맑은 공기
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_CANNOT_USE_AS_COST)
	e1:SetTR(0xff,0xff)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","M")
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","HG")
	e3:SetCode(EVENT_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCL(1,id)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		s[0]={}
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(s.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsReason(REASON_COST) then
			local tre=tc:GetReasonEffect()
			if tre and tre:IsActivated() then
				local cc=Duel.GetCurrentChain()
				s[0][cc]=true
			end
		end
		tc=eg:GetNext()
	end
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	s[0]={}
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	if s[0][cc] then
		Duel.NegateEffect(ev)
	end
end
function s.nfil3(c)
	return c:IsHasEffect(CARD_NEW_HEAVEN_AND_EARTH)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.nfil3,1,nil)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,"D")
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCL(1)
	e1:SetCondition(s.ocon31)
	e1:SetOperation(s.oop31)
	Duel.RegisterEffect(e1,tp)
end
function s.onfil31(c)
	return c:IsSetCard("신천지") and c:IsSSetable()
end
function s.ocon31(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(s.onfil31,tp,"D",0,1,nil)
end
function s.oop31(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,s.onfil31,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end