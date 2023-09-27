--오늘 한 그루의 사과나무를
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function s.tfil1(c,b,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN) or (c:IsAbleToRemove() and b)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LSTN("R"),0,1,nil)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil,b,tp)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LSTN("R"),0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil,b,tp)
	if #g>0 then
		local tc=g:GetFirst()
		local b1=tc:IsAbleToRemove(tp,POS_FACEDOWN)
		local b2=tc:IsAbleToRemove() and b
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(id,0)},
			{b2,aux.Stringid(id,1)})
		if op==1 then
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		elseif op==2 then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end