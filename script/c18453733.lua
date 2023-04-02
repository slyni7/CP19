--오드 싸이크론
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function s.tfun1(g)
	return #g&0x1==0x1
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField() and chkc:IsType(TYPE_SPELL+TYPE_TRAP)
	end
	local g=Duel.GMGroup(Card.IsType,tp,"O","O",c,TYPE_SPELL+TYPE_TRAP):Filter(Card.IsCanBeEffectTarget,nil,e)
	if chk==0 then
		return #g>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:SelectSubGroup(tp,s.tfun1,false,1,#g)
	Duel.SetTargetCard(sg)
	Duel.SOI(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end