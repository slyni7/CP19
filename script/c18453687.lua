--설화설화☆나이트피버
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FTo","M")
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCL(1)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"F","M")
	e7:SetCode(EFFECT_NIGHT_FEVER_PAYLP_TO_DRAW)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTR(1,0)
	e7:SetCondition(s.con7)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_NIGHT_FEVER_DISCARD_TO_DRAW)
	c:RegisterEffect(e8)
	if not s.global_check then
		s.global_check=true
		s[0]=0
		s[1]=0
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(s.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		s[tc:GetControler()]=s[tc:GetControler()]+1
		tc=eg:GetNext()
	end
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	s[0]=0
	s[1]=0
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCL(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(s.oop11)
	Duel.RegisterEffect(e1,tp)
end
function s.oofil11(c,e,tp)
	return c:IsSetCard("나이트피버") and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local ct=math.floor(s[tp]/2)
	if ct>0 then
		Duel.Draw(tp,ct,REASON_EFFECT)
		Duel.Recover(tp,ct*1400,REASON_EFFECT)
		if Duel.GetLocCount(tp,"M")>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SMCard(tp,s.oofil11,tp,"D",0,0,1,nil,e,tp)
			if #g>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not eg:IsContains(c)
end
function s.tfil4(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsAbleToHand()
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil4,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil4,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.con7(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)==0
end