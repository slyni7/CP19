--오직 원색만이 남아있는 공간
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","F")
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTR("M",0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,18453939))
	e2:SetValue(700)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","F")
	e3:SetCode(EFFECT_EXTRA_SQUARE_MANA)
	e3:SetTR("M",0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,18453939))
	e3:SetValue(function()
		return ATTRIBUTE_LIGHT,ATTRIBUTE_DARK
	end)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","F")
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetCL(1)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function s.tfil1(c)
	return c:IsCode(18453939) and c:IsAbleToHand()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.tfil1,tp,"D",0,0,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.tfil4(c)
	return c:IsSetCard("원색") and c:IsAbleToDeck()
		and (c:GetType()==TYPE_TRAP or c:IsType(TYPE_QUICKPLAY))
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp)
			and Duel.IEMCard(s.tfil4,tp,"H",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TODECK,nil,1,tp,"H")
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SMCard(tp,s.tfil4,tp,"H",0,1,63,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end