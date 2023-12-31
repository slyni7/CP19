--미래로부터의 고리
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetD(id,0)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC")
	e3:SetCode(EVENT_ANYTIME)
	e3:SetD(id,1)
	WriteEff(e3,3,"NO")
	Duel.RegisterEffect(e3,0)
	local e4=e3:Clone()
	Duel.RegisterEffect(e4,1)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
end
function s.nfil3(c)
	return (c:IsStatus(STATUS_CHAINING) or not c:IsLoc("H"))
		and c:IsAbleToDeck()
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IEMCard(s.nfil3,tp,0,"HOG",1,nil) then
		return false
	end
	return Duel.GetFlagEffect(tp,id)==0 and c:IsControler(tp) and c:IsLoc("DHOGR")
end
function s.ofil3(c)
	return c:IsSetCard("새턴") and c:IsFaceup()
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	Duel.ConfirmCards(1-tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GMGroup(s.nfil3,tp,0,"HOG",nil)
	local hg=g:Filter(Card.IsLoc,nil,"H")
	Duel.ConfirmCards(tp,hg)
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	if not Duel.IEMCard(s.ofil3,tp,"M",0,1,nil) then
		local lp=2700
		local eset={Duel.IsPlayerAffectedByEffect(tp,id)}
		for i=1,#eset do
			lp=lp/2
		end
		Duel.SetLP(tp,Duel.GetLP(tp)-lp)
	end
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCL(1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetOperation(s.oop31)
	Duel.RegisterEffect(e1,tp)
end
function s.oop31(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IEMCard(s.ofil3,tp,"M",0,1,nil) then
		local lp=2700
		local eset={Duel.IsPlayerAffectedByEffect(tp,id)}
		for i=1,#eset do
			lp=lp/2
		end
		Duel.SetLP(tp,Duel.GetLP(tp)-lp)
	end
end