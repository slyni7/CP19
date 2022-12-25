--모카모카☆나이트피버
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x368)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetCL(1,id)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCL(1,{id,1})
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FC","M")
	e5:SetCode(EVENT_CHAIN_SOLVED)
	WriteEff(e5,5,"NO")
	c:RegisterEffect(e5)
end
function s.tfil1(c)
	return ((c:IsMonster() and c:IsSetCard("나이트피버")) or (c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER))) and c:IsAbleToGrave()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"HD",0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"HD")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.tfil1,tp,"HD",0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		local loc=tc:GetLocation()
		Duel.SendtoGrave(g,REASON_EFFECT)
		local ct=1
		if loc==LSTN("H") then
			ct=2
		end
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function s.tfil4(c,e,tp)
	return c:IsSetCard("나이트피버") and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and s.tfil4(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil4,tp,"G",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,s.tfil4,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.con5(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_COUNTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x368,1)
	while c:IsCanRemoveCounter(tp,0x368,2,REASON_EFFECT) do
		c:RemoveCounter(tp,0x368,2,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Recover(tp,1400,REASON_EFFECT)
	end
end