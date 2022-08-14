--Brut@l Arom@ir
local m=18453204
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","S")
	e2:SetCode(EVENT_ADJUST)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"NO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","S")
	e3:SetCode(EVENT_RECOVER)
	e3:SetCountLimit(1)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FC","S")
	e4:SetCode(EVENT_ADJUST)
	e4:SetCountLimit(1)
	WriteEff(e4,4,"NO")
	c:RegisterEffect(e4)
end
function cm.nfil2(c)
	return c:IsSetCard(0x2e6) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(cm.nfil2,tp,"M",0,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GMGroup(Card.IsFaceup,tp,0,"M",nil)
	local sum=g:GetSum(cm.oval2)
	Duel.Recover(tp,sum*100,REASON_EFFECT)
end
function cm.nfil3(c)
	return c:IsSetCard(0x2e6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(aux.TRUE,tp,0,"O",1,nil)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SMCard(tp,aux.TRUE,tp,0,"O",1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(cm.nfil2,tp,"M",0,1,nil) and Duel.GetLP(1-tp)>0 and math.floor(Duel.GetLP(tp)/Duel.GetLP(1-tp))>=2
		and Duel.IEMCard(Card.IsAbleToRemove,tp,0,"HOG",1,nil)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Group.CreateGroup()
	local g1=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"O",nil)
	local g2=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"G",nil)
	local g3=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"H",nil)
	local sg=Group.CreateGroup()
	if #g1>0 and ((#g2==0 and #g3==0) or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if #g2>0 and ((#sg==0 and #g3==0) or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if #g3>0 and (#sg==0 or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:RandomSelect(tp,1)
		sg:Merge(sg3)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
