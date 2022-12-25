--세 번째 계절: 가을
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,id)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","M")
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCL(1,{id,1})
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.tfil1(c,e,tp)
	return c:IsSetCard("계절") and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function s.nfil3(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LSTN("D"))
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.nfil3,1,nil,tp)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(aux.TRUE,tp,0,"O",nil)
	if chk==0 then	
		return #g>0
	end
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(aux.TRUE,tp,0,"O",nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,1,nil)
	if #dg>0 then
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end