--vingt et un ~raison d'etre~
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function s.tfil11(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) and (c:IsFaceup() or c:IsLoc("H"))
end
function s.tfil12(c)
	return c:IsSetCard("vingt et un") and c:IsAbleToHand() and c:IsType(TYPE_PENDULUM)
end
function s.tfun1(sg,min,max)
	local fc=sg:GetFirst()
	local nc=sg:GetNext()
	return fc and nc and ((fc:GetLeftScale()==min-1 and nc:GetRightScale()==max+1)
		or (fc:GetRightScale()==min-1 and nc:GetLeftScale()==max+1)
		or (nc:GetLeftScale()==min-1 and fc:GetRightScale()==max+1)
		or (nc:GetRightScale()==min-1 and fc:GetLeftScale()==max+1))
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(s.tfil11,tp,"HE",0,nil,e,tp)
	local sg=Duel.GMGroup(s.tfil12,tp,"D",0,nil)
	local _,min=g:GetMinGroup(Card.GetLevel)
	local _,max=g:GetMaxGroup(Card.GetLevel)
	if chk==0 then
		return #g>0 and sg:CheckSubGroup(s.tfun1,2,2,min,max)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,2,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(s.tfil11,tp,"HE",0,nil,e,tp)
	local hg=Duel.GMGroup(nil,tp,"H",0,nil)
	Duel.ConfirmCards(1-tp,hg)
	if #g==0 then
		return
	end
	local sg=Duel.GMGroup(s.tfil12,tp,"D",0,nil)
	local _,min=g:GetMinGroup(Card.GetLevel)
	local _,max=g:GetMaxGroup(Card.GetLevel)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=sg:SelectSubGroup(tp,s.tfun1,false,2,2,min,max)
	if tg and #tg==2 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function s.tfil2(c)
	return c:IsSetCard("vingt et un") and c:IsAbleToDeck() and c:IsType(TYPE_PENDULUM)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"H",0,1,nil) and c:IsAbleToHand()
	end
	Duel.SOI(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SMCard(tp,s.tfil2,tp,"H",0,1,1,nil)
		if #g>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end