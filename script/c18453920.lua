--그리니치 표준시
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_RECOVER)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","FG")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","FG")
	e4:SetCode(id)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTR(1,1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(id+1)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(id+2)
	c:RegisterEffect(e6)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Recover(tp,8000,REASON_EFFECT)
	end
	if Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
		Duel.Recover(1-tp,8000,REASON_EFFECT)
	end
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost(POS_FACEDOWN)
	end
	Duel.Remove(c,POS_FACEDOWN,REASON_COST)
end
function s.tfil3(c,e,tp)
	return (c:IsSetCard("그리니치") or c:IsSetCard("새턴"))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (c:IsLoc("F") or Duel.CheckLocation(tp,LSTN("S"),5))
			and Duel.IEMCard(s.tfil3,tp,"E",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.CheckLocation(tp,LSTN("S"),5) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil3,tp,"E",0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local i=0
		while tc.eff_ct[tc][i] do
			local te=tc.eff_ct[tc][i]
			local trang=te:GetRange()
			if trang and trang&LSTN("M")~=0 then
				local e1=te:Clone()
				e1:SetRange(LSTN("F"))
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TOFIELD)
				tc:RegisterEffect(e1)
			end
			i=i+1
		end
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,0xfe)
	end
end