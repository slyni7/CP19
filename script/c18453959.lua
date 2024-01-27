--이상물질(아이딜 매터) 「청명」
local s,id=GetID()
function s.initial_effect(c)
	if not s.global_check then
		s.global_check=true
		aux.RegisterIdealMatter(c,id)
	end
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","M")
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function s.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0
end
function s.tfil2(c)
	return ((c:IsOnField() and c:IsFaceup())
		or c:IsLoc("G") or (c:IsLoc("R") and c:IsFaceup())) and (c:IsAbleToDeck() or c:IsNegatable())
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,0,"OGR",1,nil)
	end
	Duel.SOI(0,CATEGORY_TODECK,nil,1,1-tp,"OGR")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SMCard(tp,s.tfil2,tp,0,"OGR",1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then
		local code=tc:GetOriginalCodeRule()
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTR(0,"O")
		e1:SetLabel(code)
		e1:SetTarget(s.otar21)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=MakeEff(c,"FC")
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetLabel(code)
		e2:SetCondition(s.ocon22)
		e2:SetOperation(s.oop22)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTR(0,"M")
		Duel.RegisterEffect(e3,tp)
	end
end
function s.otar21(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function s.ocon22(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsOriginalCodeRule(e:GetLabel()) and rp~=tp
end
function s.oop22(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end