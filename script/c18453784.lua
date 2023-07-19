--데몬 소환사 알레이스터
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSkullProcedure(c,s.pfil1,s.pfil2,nil)
	c:SetSPSummonOnce(id)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_BE_CUSTOM_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
s.custom_type=CUSTOMTYPE_SKULL
function s.pfil1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function s.pfil2(c)
	return c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SKULL)
end
function s.tfil1(c,e,tp)
	return c:IsCanBeEffectTarget(e) and Duel.IEMCard(s.ofil1,tp,"D",0,1,nil,c)
end
function s.ofil1(c,mc)
	return mc:ListsCode(c:GetCode())
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	if chkc then
		return false
	end
	if chk==0 then
		return mg:IsExists(s.tfil1,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=mg:FilterSelect(tp,s.tfil1,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,s.ofil1,tp,"D",0,1,1,nil,tc)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return r&CUSTOMREASON_SKULL==CUSTOMREASON_SKULL
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id-1,0x2045,0x4011,2500,1200,6,RACE_FIEND,ATTRIBUTE_DARK)
	end
	Duel.SOI(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id-1,0x2045,0x4011,2500,1200,6,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,id-1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end