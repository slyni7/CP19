--사이아이린(가면을 벗은 아이)
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,s.pfil1,4,2,s.pfil2,aux.Stringid(id,0),2,s.pop1)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"S","MG")
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(18453827)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
	e2:SetCL(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function s.pfil1(c)
	return c:IsRace(RACE_ZOMBIE)
end
function s.pfil2(c,tp,lc)
	return c:IsFaceup() and c:IsSummonCode(lc,SUMMON_TYPE_XYZ,tp,18453827)
		and #c:GetEquipGroup()>0
end
function s.pop1(e,tp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,id)==0
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	return true
end
function s.cfil2(c)
	return c:IsSetCard("가면") and c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsAbleToHandAsCost()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.cfil2,tp,"S",0,1,nil) or c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	local min=0
	if not c:CheckRemoveOverlayCard(tp,1,REASON_COST) then
		min=1
	end
	local g=Duel.SMCard(tp,s.cfil2,tp,"S",0,min,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		c:RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function s.tfil2(c,e,tp)
	return ((c:IsLoc("G") and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0)
		or (c:IsLoc("M") and c:IsControlerCanBeChanged()))
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"G","MG",1,nil,e,tp)
	end
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"G")
	Duel.SPOI(0,CATEGORY_CONTROL,nil,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SMCard(tp,s.tfil2,tp,"G","MG",1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsLoc("G") then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif tc:IsLoc("M") then
			Duel.GetControl(tc,tp)
		end
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_ZOMBIE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end