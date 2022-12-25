--사야사야☆나이트피버
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetCL(1,id)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_NIGHT_FEVER_PAYLP_TO_RECOVER)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTR(1,0)
	e3:SetCondition(s.con3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NIGHT_FEVER_DISCARD_TO_RECOVER)
	c:RegisterEffect(e4)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_DISCARD+REASON_COST)
end
function s.tfil1(c)
	return c:IsSetCard("나이트피버") and c:IsAbleToHand() and c:IsMonster() and not c:IsCode(id)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	Duel.SPOI(0,CATEGORY_TOHAND,nil,1,tp,"G")
end
function s.ofil1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SMCard(tp,s.ofil1,tp,"G",0,0,1,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function s.cfil21(c)
	return c:IsAbleToDeckAsCost() and c:IsSetCard("나이트피버") and c:IsMonster() and not c:IsCode(id)
end
function s.cfil22(c)
	return c:IsAbleToDeckAsCost() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GMGroup(s.cfil21,tp,"G",0,nil)
	local g2=Duel.GMGroup(s.cfil22,tp,"G",0,nil)
	if chk==0 then
		return #g1>0 and #g2>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	Duel.SendtoDeck(sg1,nil,2,REASON_COST)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or c:IsAbleToHand()
	end
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SPOI(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	aux.ToHandOrElse(c,tp,
		function(sc) return sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0 end,
		function(sc) Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) end,
		aux.Stringid(id,0)
	)
end
function s.con3(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)==0
end