--Look into my eyes
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","F")
	e2:SetCode(EFFECT_DECREASE_SKULL)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,{id,1})
	e2:SetTR(1,0)
	e2:SetTarget(s.tar2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"G")
end
function s.ofil1(c,e,tp)
	return (c:IsCode(70781052) or c:IsSetCard(0x2045)) and
		(((c:IsLoc("D") and c:IsAbleToHand())
			or (c:IsLoc("G") and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) and Duel.GetLocCount(tp,"M")>0))
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,s.ofil1,tp,"DG",0,0,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			if tc:IsLoc("D") then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			else
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function s.tar2(e,c,skc)
	return (c:IsCode(70781052) or c:IsSetCard(0x2045)) or (skc:IsCode(70781052) or skc:IsSetCard(0x2045))
end