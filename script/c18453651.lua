--초월을 거듭하여
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,id)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","G")
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"NTO")
	e2:SetCost(aux.bfgcost)
	c:RegisterEffect(e2)
end
function s.tfil1(c)
	return c:IsMonster() and c:IsSetCard("초월하여") and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.nfil2(c,tp)
	return c:IsLoc("H") and c:IsControler(tp) and c:IsSetCard("초월하여") and c:IsMonster()
		and not c:IsReason(REASON_DRAW)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and eg:IsExists(s.nfil2,1,nil,tp)
end
function s.tfil2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and s.nfil2(c,tp)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.tfil2,nil,e,tp)
	if chk==0 then
		return #g>0 and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SetTargetCard(g)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"H")
end
function s.ofil2(c,e,tp)
	return c:IsRelateToEffect(e) and s.tfil2(c,e,tp)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	local g=eg:Filter(s.ofil2,nil,e,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end