--신천지의 파란 하늘
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTR(1,1)
	e1:SetValue(s.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","HG")
	e2:SetCode(EVENT_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,id)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function s.val1(e,re,rp)
	local rc=re:GetHandler()
	return not (rc:IsLoc("S") and rc:IsFacedown())
		and (not Duel.IsMainPhase() or Duel.GetTurnPlayer()~=rp or Duel.GetCurrentChain()>0)
end
function s.nfil2(c)
	return c:IsHasEffect(CARD_NEW_HEAVEN_AND_EARTH)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.nfil2,1,nil)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCL(1)
	e1:SetCondition(s.ocon21)
	e1:SetOperation(s.oop21)
	Duel.RegisterEffect(e1,tp)
end
function s.onfil21(c,e,tp)
	return not c:IsCode(id) and c:IsSetCard("신천지") and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.ocon21(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(s.onfil21,tp,"D",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
end
function s.oop21(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.onfil21,tp,"D",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end