--딜레이드 이프
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddDelightProcedure(c,s.pfil1,1,1,s.pfun1)
	local e1=MakeEff(c,"SC")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetCL(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTR(1,1)
	e3:SetValue(s.val3)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		s[0]={}
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_BREAK_EFFECT)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckEvent(EVENT_CHAINING) then
		s[0]={}
	end
end
s.square_mana={ATTRIBUTE_DIVINE,0x0,0x0,ATTRIBUTE_LIGHT}
s.custom_type=CUSTOMTYPE_SQUARE+CUSTOMTYPE_DELIGHT
function s.pfil1(c)
	return c:IsLoc("M") and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function s.pfun1(g)
	local st=s.square_mana
	return aux.IsFitSquare(g,st)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e2)
end
function s.cfil2(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.cfil2,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,s.cfil2,tp,"G",0,1,1,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function s.tfil2(c)
	return c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsAbleToHand() and c:IsHasSquareMana(ATTRIBUTE_DIVINE)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.val3(e,re,tp)
	for _,te in pairs(s[0]) do
		if re==te then
			return true
		end
	end
	return false
end