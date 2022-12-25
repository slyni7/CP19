--나태의 지명자
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetD(id,0)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","M")
	e3:SetCode(EVENT_REMOVE)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
end
function s.tfil1(c,e,tp)
	return c:IsSetCard("지명자") and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsCode(id)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and s.tfil1(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil1,tp,"G",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,s.tfil1,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function s.ofil3(c)
	return c:IsFaceup() and c:IsMonster()
end
function s.oval3(c)
	local max=0
	if c:GetAttack()>max then
		max=c:GetAttack()
	end
	if c:GetDefense()>max then
		max=c:GetDefense()
	end
	return max
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsSetCard("지명자") and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		local g=eg:Filter(s.ofil3,nil)
		if #g>0 then
			local sum=g:GetSum(s.oval3)
			Duel.Hint(HINT_CARD,0,id)
			Duel.Recover(tp,sum,REASON_EFFECT)
		end
	end
end