--죽음을 초월하여
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddBeyondProcedure(c,nil,">","BYD:ATK","BYD:LV")
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
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
function s.cost1(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetLabel()|0x10000)
	return true
end
function s.cfil1(c,bool,e,tp)
	if not c:IsAbleToGraveAsCost() or not c:IsCustomType(CUSTOMTYPE_BEYOND) then
		return false
	end
	local loc=0
	if bool then
		loc="G"
	end
	return Duel.IEMCard(s.tfil1,tp,loc,"MG",1,nil,e,tp,c:GetAttack())
end
function s.tfil1(c,e,tp,atk)
	return ((c:IsLoc("G") and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocCount(tp,"M")>0)
		or (c:IsLoc("M") and c:IsControlerCanBeChanged())) and c:GetAttack()<atk
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=e:GetLabel()&0x1~=0
	local b2=e:GetLabel()&0x10000~=0
	if chk==0 then
		if not b2 then
			return false
		end
		return Duel.IEMCard(s.cfil1,tp,"E",0,1,nil,b1,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.cfil1,tp,"E",0,1,1,nil,b1,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"G")
	Duel.SPOI(0,CATEGORY_CONTROL,nil,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	local atk=bc:GetTextAttack()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local loc=0
	if e:GetLabel()&0x1~=0 then
		loc="G"
	end
	local g=Duel.SMCard(tp,s.tfil1,tp,loc,"MG",1,1,nil,e,tp,atk)
	local tc=g:GetFirst()
	if tc then
		if tc:IsLoc("G") then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		elseif tc:IsLoc("M") then
			Duel.GetControl(tc,tp)
		end
	end
end
function s.tfil2(c,e,tp)
	return (c:IsLoc("G") and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocCount(tp,"M")>0)
		or (c:IsLoc("M") and c:IsControlerCanBeChanged())
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc=0
		if e:GetLabel()==1 then
			loc="G"
		end
		return Duel.IEMCard(s.tfil2,tp,loc,"MG",1,nil,e,tp)
	end
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"G")
	Duel.SPOI(0,CATEGORY_CONTROL,nil,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocCount(tp,"M")
	if ct<1 then
		return
	end
	local loc=0
	if e:GetLabel()==1 then
		loc="G"
	end
	local g=Duel.GMGroup(s.tfil2,tp,loc,"MG",nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local sg=g:Select(tp,1,ct,nil)
	if #sg>0 then
		local mg=sg:Filter(Card.IsLoc,nil,"M")
		Duel.GetControl(mg,tp)
		local gg=sg:Filter(Card.IsLoc,nil,"G")
		Duel.SpecialSummon(gg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end