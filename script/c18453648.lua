--한계를 초월하여
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddBeyondProcedure(c,nil,">","BYD:ATK","BYD:DEF")
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(s.tar1)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(s.val2)
	e2:SetCondition(s.con1)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCL(1,id)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
s.custom_type=CUSTOMTYPE_BEYOND
function s.con1(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_BEYOND)
end
function s.tar1(e,c)
	return c:GetAttack()<e:GetHandler():GetAttack() and not c:IsCustomType(CUSTOMTYPE_BEYOND)
end
function s.val2(e,re,tp)
	local rc=re:GetHandler()
	return rc:GetDefense()>e:GetHandler():GetDefense() and not rc:IsCustomType(CUSTOMTYPE_BEYOND)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_BEYOND,tp,true,true)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_BEYOND,tp,tp,true,true,POS_FACEUP) then
		c:CompleteProcedure()
	end
end