--페어리테일-크루얼
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSkullProcedure(c,s.pfil1,s.pfil1,nil)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCountLimit(1,id)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","MG")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetCountLimit(1,{id,1})
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
s.custom_type=CUSTOMTYPE_SKULL
function s.pfil1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttack(1850)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SKULL)
end
function s.tfil1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttack(1850) and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and s.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil1,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,s.tfil1,tp,"G",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function s.tfil2(c)
	return c:IsAttack(1850) and c:IsRace(RACE_SPELLCASTER) and c:IsSummonable(true,nil)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"H",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SMCard(tp,s.tfil2,tp,"H",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end