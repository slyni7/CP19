--영원히 행복한 성탄절(이터널 디셈버　)
local m=18453404
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_FUSION_SUMMON+CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER+CATEGORY_TOGRAVE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","S")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function cm.tfil1(c)
	return c:IsSetCard(0x2cf) and c:IsAbleToGrave() and not c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,2,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,2,tp,"D")
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,1225)
end
function cm.ofil1(c,e,tp,g)
	--not fully implemented
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x2cf)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(g,nil,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GMGroup(cm.tfil1,tp,"D",0,nil)
	if #g<2 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,2,2,nil)
	if Duel.SendtoGrave(sg,REASON_EFFECT)>0 and Duel.Recover(tp,1225,REASON_EFFECT)>0 then
		local fg=Duel.GMGroup(cm.ofil1,tp,"E",0,nil,e,tp,sg)
		if #fg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,00)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=fg:Select(tp,1,1,nil):GetFirst()
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,tp)
	return #g==2 and g:IsExists(Card.IsSetCard,1,nil,0x2cf) and not g:IsExists(Card.IsCode,1,nil,m)
end
function cm.tfun2(g)
	local tc=g:GetFirst()
	local nc=g:GetNext()
	return (tc:IsAbleToHand() and nc:IsAbleToDeck()) or (tc:IsAbleToDeck() and nc:IsAbleToHand())
		and g:FilterCount(Card.IsLoc,nil,"G")==2
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	local g=eg:Filter(Card.IsControler,nil,tp)
	if chk==0 then
		return g:CheckSubGroup(cm.tfun2,2,2)
	end
	Duel.SetTargetCard(g)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SOI(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	if #g1==0 then
		return
	end
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
	g:Sub(g1)
	if #g>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end