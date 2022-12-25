--불보커 시무르그
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,3,2,s.ovtfil3,aux.Stringid(id,0),2,s.pop1)
	c:EnableReviveLimit()
	--atk
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(s.val1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(s.val2)
	c:RegisterEffect(e2)
	--search
	local e3=MakeEff(c,"I","M")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCL(1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_DETACH_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCL(1)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
end
function s.ovtfil3(c,tp,lc)
	return c:IsFaceup() and c:IsSetCard(0x12d,lc,SUMMON_TYPE_XYZ,tp) and not c:IsSummonCode(lc,SUMMON_TYPE_XYZ,tp,id)
end
function s.pop1(e,tp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,id)==0
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	return true
end
function s.vfil1(c)
	return c:IsSetCard(0x12d) and c:GetAttack()>=0
end
function s.val1(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(s.vfil1,nil)
	return g:GetSum(Card.GetAttack)
end
function s.vfil2(c)
	return c:IsSetCard(0x12d) and c:GetDefense()>=0
end
function s.val2(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(s.vfil2,nil)
	return g:GetSum(Card.GetDefense)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.tfil3(c)
	return c:IsRace(RACE_WINGEDBEAST) and c:IsSummonableCard() and c:IsAbleToHand()
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.tfil4(c,e,tp)
	return c:IsSetCard(0x12d) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil4,tp,"D",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SMCard(tp,s.tfil4,tp,"D",0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end