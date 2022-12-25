--시간을 초월하여
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddBeyondProcedure(c,nil,">","BYD:LV","BYD:DEF")
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,1,"N")
	WriteEff(e2,2,"TO")
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
function s.tfil1(c)
	return c:IsCustomType(CUSTOMTYPE_BEYOND) and not c:IsStatus(STATUS_PROC_COMPLETE) and c:IsFaceup()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("MG") and chkc:IsControler(tp) and s.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil1,tp,"MG",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.STarget(tp,s.tfil1,tp,"MG",0,1,1,nil)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetFirstTarget()
	if bc:IsRelateToEffect(e) then
		bc:CompleteProcedure()
		if c:IsRelateToEffect(e) and e:GetLabel()==1 then
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
			if blv2 then
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetValue(blv2)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
			end
			if batk2 then
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(blv2)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
			end
			if bdef2 then
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_UPDATE_DEFENSE)
				e1:SetValue(blv2)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
			end
		end
	end
end
function s.tfil2(c,e,tp)
	return c:IsSetCard("초월하여") and c:IsCustomType(CUSTOMTYPE_BEYOND) and c:IsLevelBelow(7)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(s.tfil2,tp,"E",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocCount(tp,"M")
	if ct<1 then
		return
	end
	local g=Duel.GMGroup(s.tfil2,tp,"E",0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if e:GetLabel()~=1 then
		ct=1
	end
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end