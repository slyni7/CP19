--확률을 초월하여
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddBeyondProcedure(c,nil,">","BYD:DEF","BYD:ATK")
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(2,id)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_GRAVE)
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
function s.tfil11(c,e,tp,bc,bool)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then
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
	if bool then
		local bg=Duel.GMGroup(s.tfil12,tp,"M",0,nil)
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
function s.tfil12(c)
	return c:IsCustomType(CUSTOMTYPE_BEYOND) and (c:IsFaceup() or c:IsLoc("G"))
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and s.tfil11(chkc,e,tp,c,e:GetLabel()==1)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IETarget(s.tfil11,tp,"G",0,1,nil,e,tp,c,e:GetLabel()==1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,s.tfil11,tp,"G",0,1,1,nil,e,tp,c,e:GetLabel()==1)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end