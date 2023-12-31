--±âµ¿È¯¼ö ½ºÆ®·Õ °¡Á¬Æ®
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"FTo","H")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","M")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_ATKCHANGE)
	e3:SetCL(1)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetTR("M","M")
	e3:SetTarget(s.tar4)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
s.listed_names={18453909,18453910,18453911}
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,"°¡Á¬Æ®")
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
function s.nfil31(c)
	return c:IsCode(18453909) and c:IsFaceup()
end
function s.nfil32(c)
	return c:IsCode(18453910) and c:IsFaceup()
end
function s.nfil33(c)
	return c:IsCode(18453911) and c:IsFaceup()
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(s.nfil31,tp,"O",0,1,nil)
		and Duel.IEMCard(s.nfil32,tp,"O",0,1,nil)
		and Duel.IEMCard(s.nfil33,tp,"O",0,1,nil)
end
function s.tfil3(c)
	return c:IsSetCard("°¡Á¬Æ®") and c:IsSpellTrap() and c:IsAbleToHand()
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if c:IsRelateToEffect(e) then
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e1:SetValue(3000)
			c:RegisterEffect(e1)
		end
	end
end
function s.tar4(e,c)
	local handler=e:GetHandler()
	return c==handler or c==handler:GetBattleTarget()
end