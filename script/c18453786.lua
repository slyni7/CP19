--데몬 소환 토큰 소환
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,4,2,s.pfil1,aux.Stringid(id,0),2,s.pop1)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function s.pfil1(c,tp,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x45) and c:IsLevelAbove(6) and not c:IsType(TYPE_EFFECT)
end
function s.pop1(e,tp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,id)==0
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	return true
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end
function s.tfil1(c)
	return c:IsSetCard(0x45) and not c:IsType(TYPE_EFFECT)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local ct=og:FilterCount(s.tfil1,nil)
	if chk==0 then
		return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
			and Duel.IsPlayerCanSpecialSummonMonster(tp,18453783,0x2045,0x4011,2500,1200,6,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local og=c:GetOverlayGroup()
	local ct=og:FilterCount(s.tfil1,nil)
	if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18453783,0x2045,0x4011,2500,1200,6,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) then
		for i=1,ct do
			local token=Duel.CreateToken(tp,18453783)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
		Duel.SpecialSummonComplete()
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local ct=og:FilterCount(s.tfil1,nil)
	e:SetLabel(ct)
	return ct>0
end
function s.tfil2(c)
	return c:IsSetCard(0x45) and not c:IsType(TYPE_EFFECT) and c:IsAbleToHand()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and s.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil2,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,s.tfil2,tp,"G",0,1,e:GetLabel(),nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end