--포스트루드 카드
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
s.listed_names={CARD_CARD_EJECTOR}
function s.tfil1(c)
	return (c:IsCode(CARD_CARD_EJECTOR) or aux.IsCodeListed(c,CARD_CARD_EJECTOR)) and c:IsAbleToDeck() and not c:IsCode(id)
		and c:IsFaceup()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IETarget(s.tfil1,tp,"GR",0,3,nil) and Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.STarget(tp,s.tfil1,tp,"GR",0,3,3,nil)
	Duel.SOI(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	if Duel.IsPlayerAffectedByEffect(tp,id) then
		return
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
end