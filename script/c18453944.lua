--원색석학의 준비
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function s.tfil1(c)
	return c:IsAbleToHand() and c:IsCode(18453939)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DG")
end
function s.ofil1(c)
	return c:IsSetCard("원색")
		and (c:GetType()==TYPE_TRAP or c:IsType(TYPE_QUICKPLAY)) and c:IsAbleToHand()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SMCard(tp,s.ofil1,tp,"DG",0,0,1,nil)
		if #sg>0 then
			local tc=sg:GetFirst()
			local loc=tc:GetLocation()
			Duel.BreakEffect()
			if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 and loc&LSTN("D")>0 then
				Duel.ShuffleDeck(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local tg=Duel.SMCard(tp,Card.IsAbleToDeck,tp,"H",0,1,1,nil)
				Duel.DisableShuffleCheck()
				Duel.SendtoDeck(tg,nil,1,REASON_EFFECT)
			end
		end
	end
end
function s.tfil2(c)
	return c:IsCode(18453939) and c:IsFaceup()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and s.tfil2(chkc) and chkc:IsControler(tp)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil2,tp,"M",0,1,nil)
	end
	local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	Duel.SetTargetParam(att)
	Duel.STarget(tp,s.tfil2,tp,"M",0,1,1,nil)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local att=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(function()
			return att
		end)
		tc:RegisterEffect(e1)
	end
end