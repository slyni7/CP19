--만물을 초월하여
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddBeyondProcedure(c,nil,">","BYD:DEF","BYD:LV")
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
end
s.custom_type=CUSTOMTYPE_BEYOND
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_BEYOND) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	return true
end
function s.tfil11(c,bc)
	if not (c:IsAbleToHand() and c:IsMonster()) then
		return false
	end
	local blv1,blv2=bc:GetBYDLV()
	local batk1,batk2=bc:GetBYDATK()
	local bdef1,bdef2=bc:GetBYDDEF()
	if blv1 and not blv2 then
		blv2=bc:GetOriginalLevel()
	end
	if batk1 and not batk2 then
		batk2=bc:GetTextAttack()
	end
	if bdef1 and not bdef2 then
		bdef2=bc:GetTextDefense()
	end
	if blv2 and blv2==c:GetLevel() then
		return true
	end
	if batk2 and batk2==c:GetAttack() then
		return true
	end
	if bdef2 and bdef2==c:GetDefense() then
		return true
	end
	return false
end
function s.tfil12(c,e,tp)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then
		return false
	end
	local bg=Duel.GMGroup(s.tfil13,tp,"MG",0,nil)
	local bc=bg:GetFirst()
	while bc do
		local blv1,blv2=bc:GetBYDLV()
		local batk1,batk2=bc:GetBYDATK()
		local bdef1,bdef2=bc:GetBYDDEF()
		if blv1 and not blv2 then
			blv2=bc:GetOriginalLevel()
		end
		if batk1 and not batk2 then
			batk2=bc:GetTextAttack()
		end
		if bdef1 and not bdef2 then
			bdef2=bc:GetTextDefense()
		end
		if blv2 and blv2==c:GetLevel() then
			return true
		end
		if batk2 and batk2==c:GetAttack() then
			return true
		end
		if bdef2 and bdef2==c:GetDefense() then
			return true
		end
		bc=bg:GetNext()
	end
	return false
end
function s.tfil13(c)
	return c:IsCustomType(CUSTOMTYPE_BEYOND) and (c:IsFaceup() or c:IsLoc("G"))
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IEMCard(s.tfil11,tp,"D",0,1,nil,c)
	local b2=e:GetLabel()==1 and Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(s.tfil12,tp,"D",0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,id)==0
	if chk==0 then
		return b1 or b2
	end
	if Duel.GetFlagEffect(tp,id)==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
		Duel.SPOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
		Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IEMCard(s.tfil11,tp,"D",0,1,nil,c)
	local b2=e:GetLabel()==1 and Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(s.tfil12,tp,"D",0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,id)==0
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,s.tfil12,tp,"D",0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,s.tfil11,tp,"D",0,1,1,nil,c)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end