--전후열반(니르바나 애프터)
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(Card.IsDiscardable,tp,"H",0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,Card.IsDiscardable,tp,"H",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function s.tfil1(c,e)
	return (c:GetSequence()<5 or c:IsLoc("M")) and c:IsCanBeEffectTarget(e)
end
function s.tfun1(g)
	return g:FilterCount(Card.IsLoc,nil,"M")<2 and g:FilterCount(Card.IsLoc,nil,"S")<2
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return false
	end
	local g=Duel.GMGroup(s.tfil1,tp,"O","O",c,e)
	if chk==0 then
		return g:CheckSubGroup(s.tfun1,1,2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:SelectSubGroup(tp,s.tfun1,false,1,2)
	Duel.SetTargetCard(sg)
	if #sg==2 then
		Duel.SetChainLimit(aux.FALSE)
	end
	Duel.SOI(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end