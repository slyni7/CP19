--인투 디 언논 에어
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCountLimit(1,{id,1})
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function s.cfil1(c)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,s.cfil1,tp,"G",0,0,99,nil)
	e:SetLabel(#g)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
end
function s.tfil1(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(0)
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	Duel.SPOI(0,CATEGORY_TOHAND,nil,1,tp,"R")
end
function s.ofil11(c)
	return c:IsCode(34022290) and not c:IsPublic()
end
function s.ofil12(c)
	return c:IsFacedown() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_WIND+ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	local cg=Duel.GMGroup(s.ofil11,tp,"H",0,nil)
	local sg=Duel.GetMatchingGroup(s.ofil12,tp,LSTN("R"),0,nil)
	if e:GetLabel()>0 and #cg>0 and #sg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local ag=cg:Select(tp,0,1,nil)
		if #ag>0 then
			Duel.ConfirmCards(1-tp,ag)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=sg:Select(tp,1,1,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function s.cfil2(c)
	return c:IsCode(34022290) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.cfil2,tp,"O",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SMCard(tp,s.cfil2,tp,"O",0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
	Duel.ConfirmCards(1-tp,g)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck()
	end
	Duel.SOI(0,CATEGORY_TODECK,c,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.GetFieldGroupCount(tp,LSTN("D"),0)==0 then
			Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
		else
			local opt=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
			Duel.SendtoDeck(c,nil,opt,REASON_EFFECT)
		end
	end
end