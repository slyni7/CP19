--인색의 지명자
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"FTo","H")
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetTR("H",0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,"지명자"))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard("지명자") and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end