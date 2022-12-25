--여섯 번째 계절: 마법
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"F","M")
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTR(1,0)
	e1:SetCL(1,id)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHandAsCost()
	end
	Duel.SendtoHand(c,nil,REASON_COST)
end
function s.tfil2(c,e,tp)
	return c:IsSetCard("계절") and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return 
	end
	if chk==0 then
		return Duel.IETarget(s.tfil2,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,s.tfil2,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end