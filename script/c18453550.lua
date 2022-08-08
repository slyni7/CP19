--쇼팽 에튀드 10-3 이별
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_CHAINING)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function s.con1(e)
	local c=e:GetHandler()
	return c:IsPublic()
end
function s.tfil2(c)
	return c:IsSetCard(0x2f3) and c:IsFaceup()
end
function s.tval2(c)
	return c:GetType()&0x7
end
function s.tfun2(g)
	local dg1=g:Filter(Card.IsLoc,nil,"H")
	local dg2=g:Filter(Card.IsLoc,nil,"O")
	local dg3=g:Filter(Card.IsLoc,nil,"G")
	return #dg1==#dg2 and #dg1==#dg3
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(s.tfil2,tp,"O",0,nil)
	local dg=Duel.GMGroup(Card.IsAbleToDeck,tp,0,"HOG",nil)
	local ct=g:GetClassCount(s.tval2)
	if chk==0 then
		return ct>0 and dg:CheckSubGroup(s.tfun2,3,3)
	end
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	local g=Duel.GMGroup(s.tfil2,tp,"O",0,nil)
	local ct=g:GetClassCount(s.tval2)
	if ct==0 then
		return
	end
	local dg=Duel.GMGroup(Card.IsAbleToDeck,tp,0,"HOG",nil)
	local sg=dg:CheckSubGroup(s.tfun2,3,3*ct)
	if #sg>0 then
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end