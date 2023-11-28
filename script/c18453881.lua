--신천지를 수놓은 별
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetCL(1,id)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","G")
	e2:SetCode(EVENT_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function s.tfil1(c)
	return c:IsSetCard("신천지") and c:IsMonster() and c:IsAbleToHand() and c:IsAbleToGrave()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,3,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,2,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(s.tfil1,tp,"D",0,nil)
	if #g<3 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,3,3,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=sg:Select(1-tp,1,1,nil)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	sg:Sub(tg)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function s.nfil2(c)
	return c:IsHasEffect(CARD_NEW_HEAVEN_AND_EARTH)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.nfil2,1,nil)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SOI(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.ofil21(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGrave()
end
function s.ofil22(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsFaceup()
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)>0 and c:IsLoc("D") then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tc=Duel.SMCard(tp,s.ofil21,tp,"D",0,0,1,nil):GetFirst()
			if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLoc("G") then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				local sc=Duel.SMCard(tp,s.ofil22,tp,0,"M",0,1,nil):GetFirst()
				if sc then
					local e1=MakeEff(c,"S","M")
					e1:SetCode(CARD_NEW_HEAVEN_AND_EARTH)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(math.max(tc:GetAttack(),0))
					sc:RegisterEffect(e1)
				end
			end
		end
	end
end