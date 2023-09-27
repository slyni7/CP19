--말머리 가면
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"SC","S")
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetTarget(s.tar1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	c:SetUniqueOnField(1,0,id)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"S")
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(s.val4)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FC","S")
	e5:SetCode(EVENT_ADJUST)
	WriteEff(e5,5,"O")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"FTo","S")
	e6:SetCode(EVENT_EQUIP)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetCL(1)
	WriteEff(e6,6,"NTO")
	c:RegisterEffect(e6)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReason(REASON_LOST_TARGET)
	end
	return true
end
function s.tfil21(c)
	return c:IsCode(18453827) and c:IsFaceup()
end
function s.tfil22(c,e,tp)
	if Duel.IEMCard(s.tfil21,tp,"O",0,1,nil) then
		if c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			return true
		end
	end
	return c:IsCode(18453827) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return s.tfil22(chkc,e,tp) and c:IsLoc("G") and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	if chk==0 then
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Group.CreateGroup()
	if Duel.GetLocCount(tp,"M")>0 then
		Duel.STarget(tp,s.tfil22,tp,"G",0,0,1,nil,e,tp)
	end
	if #g>0 then
		Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"G")
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	c:Type(TYPE_SPELL)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(TYPE_SPELL+TYPE_EQUIP)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetCL(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e1)
	e2:SetOperation(s.oop22)
	Duel.RegisterEffect(e2,tp)
end
function s.oop22(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	c:Type(TYPE_SPELL+TYPE_EQUIP)
	te:Reset()
	e:Reset()
end
function s.val4(e,c)
	return c:IsRace(RACE_ZOMBIE)
end
function s.ofil5(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsFaceup()
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SMCard(tp,s.ofil5,tp,"M","M",1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,c,tc)
		end
	end
end
function s.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c)
end
function s.tar6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return s.tfil22(chkc,e,tp) and c:IsLoc("G") and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IETarget(s.tfil22,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,s.tfil22,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"G")
end
function s.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end