--매스틸러 시무르그
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOGRAVE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","G")
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
function s.tfil1(c)
	return c:IsSetCard(0x12d) and c:IsMonster() and c:IsAbleToGrave()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function s.tfil2(c)
	return c:IsSetCard(0x12d) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1) or (Duel.GetFlagEffect(tp,id)==0 and Duel.IEMCard(s.tfil2,tp,"D",0,1,nil))
	end
	if Duel.GetFlagEffect(tp,id)==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
		Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
		Duel.SPOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	else
		e:SetCategory(CATEGORY_DRAW)
		Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
		and Duel.GetFlagEffect(tp,id)==0 and (not Duel.IsPlayerCanDraw(tp,1) or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.nfil3(c)
	return c:IsCode(18453669) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(s.nfil3,tp,"M",0,1,nil)
end
function s.tfil3(c)
	return c:IsLevelBelow(6) and c:IsFaceup()
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and chkc:IsControler(tp) and s.tfil3(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil3,tp,"M",0,1,nil) and Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,18453669,0x12d,TYPES_TOKEN,0,0,1,RACE_WINGEDBEAST,ATTRIBUTE_DARK)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.STarget(tp,s.tfil3,tp,"M",0,1,1,nil)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SOI(0,CATEGORY_TOKEN,nil,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(7)
		tc:RegisterEffect(e1)
		if tc:GetLevel()==7 and Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,18453669,0x12d,TYPES_TOKEN,0,0,1,RACE_WINGEDBEAST,ATTRIBUTE_DARK) then
			local token=Duel.CreateToken(tp,18453697)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e2=MakeEff(c,"S")
			e2:SetCode(EFFECT_SIMORGH_EGG_TOKEN)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
end