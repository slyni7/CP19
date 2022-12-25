--생명을 초월하여
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddBeyondProcedure(c,nil,">","BYD:LV","BYD:ATK")
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,id)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
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
function s.tfil1(c,bool)
	return (c:IsSetCard("초월을") or (bool and c:IsSetCard(0xe94))) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil,e:GetLabel()==1)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil,e:GetLabel()==1):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_BEYOND) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	return true
end
function s.tfil21(c,e,tp,bool)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then
		return false
	end
	if c:IsSetCard("초월하여") and not c:IsCode(id) then
		return true
	end
	if bool then
		local bg=Duel.GMGroup(s.tfil22,tp,"MG",0,nil)
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
	end
	return false
end
function s.tfil22(c)
	return c:IsCustomType(CUSTOMTYPE_BEYOND) and (c:IsFaceup() or c:IsLoc("G"))
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil21,tp,"DG",0,1,nil,e,tp,e:GetLabel()==1) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"DG")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SMCard(tp,s.tfil21,tp,"DG",0,1,1,nil,e,tp,e:GetLabel()==1):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end