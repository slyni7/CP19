--​인클루드 카드
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
s.listed_names={CARD_CARD_EJECTOR}
function s.tfil1(c,e,tp)
	return c:IsCode(CARD_CARD_EJECTOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"H",0,1,nil,e,tp) and Duel.IsPlayerCanDraw(tp,2)
			and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"H")
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,s.tfil1,tp,"H",0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
	if Duel.IsPlayerAffectedByEffect(tp,id) then
		return
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(s.ocon12)
	e2:SetOperation(s.oop12)
	Duel.RegisterEffect(e2,tp)
end
function s.onfil12(c,tp)
	return c:GetReasonPlayer()==tp and c:IsReason(REASON_EFFECT) and c:GetReasonEffect():GetHandler():IsCode(CARD_CARD_EJECTOR)
end
function s.ocon12(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.onfil12,nil,tp)
	return #g>0
end
function s.oop12(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(s.onfil12,nil,tp)
	local tc=g:GetFirst()
	while tc do
		local ec=tc:GetReasonEffect():GetHandler()
		if ec:IsLoc("M") and ec:IsFaceup() then
			Duel.Hint(HINT_CARD,0,id)
			Duel.HintSelection(tc)
			local atk=math.max(tc:GetAttack(),0)
			local def=math.max(tc:GetDefense(),0)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(atk)
			ec:RegisterEffect(e1)
			local e2=MakeEff(c,"S")
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(def)
			ec:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
end