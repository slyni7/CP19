--새벽 3시에 햄버거 먹는 사람이 어딨냐고!
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	local e3=MakeEff(c,"I","P")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCL(1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		s[0]={}
		s[1]={}
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	s[0]={}
	s[1]={}
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,800)
	end
	Duel.PayLPCost(tp,800)
end
function s.tfil3(c,e,tp)
	return c:IsSetCard("버거") and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and not s[tp][c:GetCode()]
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil3,tp,"D",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil3,tp,"D",0,1,1,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		s[tp][tc:GetCode()]=true
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
