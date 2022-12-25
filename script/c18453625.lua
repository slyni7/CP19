--계절의 구성요소: 새파란 이성
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,id)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function s.tfil1(c)
	return c:IsSetCard("계절") and c:IsAbleToHand() and not c:IsCode(id)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=MakeEff(c,"F","M")
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetTarget(function(_,c) return c:IsLoc("E") end)
		c:RegisterEffect(e1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.cfil2(c)
	return c:IsSetCard("계절") and c:IsAbleToRemoveAsCost()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.cfil2,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,s.cfil2,tp,"G",0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end