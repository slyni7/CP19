--이상물질(아이딜 매터) 「청천」
local s,id=GetID()
function s.initial_effect(c)
	if not s.global_check then
		s.global_check=true
		aux.RegisterIdealMatter(c,id)
	end
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","F")
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetD(id,0)
	e2:SetTR("HM",0)
	e2:SetTarget(s.tar2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","F")
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTR("M",0)
	e3:SetValue(600)
	e3:SetTarget(s.tar2)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","F")
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetTR(0,"M")
	e4:SetValue(-600)
	c:RegisterEffect(e4)
end
function s.ofil1(c)
	return c:IsSetCard("이상물질(아이딜 매터)") and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.ofil1,tp,"D",0,0,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.tar2(e,c)
	return c:IsSetCard("이상물질(아이딜 매터)")
end