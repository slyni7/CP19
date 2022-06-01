--举府胶 绊胶飘
local m=18453013
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e2,2,"NCO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","S")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","G")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCountLimit(1,m+1)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function cm.nfil2(c)
	return c:IsCode(m) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(cm.nfil2,tp,"O",0,1,nil)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	c:SetStatus(STATUS_EFFECT_ENABLED,true)
end
function cm.ofil2(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup() and c:IsHasExactSquareMana(ATTRIBUTE_EARTH)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.otar21)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	Duel.RegisterEffect(e2,tp)
	local tg=Duel.GMGroup(cm.ofil2,tp,"M",0,nil)
	if #tg>0 and Duel.GetFlagEffect(tp,m)<1 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=tg:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.BreakEffect()
		local e3=MakeEff(c,"S")
		e3:SetCode(EFFECT_SQUARE_MANA_DECLINE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(cm.oval23)
		sc:RegisterEffect(e3)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		local e4=MakeEff(c,"F")
		e4:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e4:SetDescription(aux.Stringid(m,1))
		e4:SetReset(RESET_PHASE+PHASE_END)
		e4:SetTR("HM",0)
		e4:SetTarget(cm.otar21)
		Duel.RegisterEffect(e4,tp)
	end
end
function cm.otar21(e,c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE)
end
function cm.oval23(e,c)
	return ATTRIBUTE_EARTH
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LSTN("HO"))
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DAMAGE,nil,0,tp,ct*100)
end
function cm.ofil3(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CHANGE_SUMMON_TYPE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(SUMMON_TYPE_NORMAL)
	e1:SetTR("M",0)
	e1:SetTarget(cm.otar31)
	Duel.RegisterEffect(e1,tp)
	local sg=Duel.GMGroup(cm.ofil3,tp,"M",0,nil)
	local sc=sg:GetFirst()
	if sc then
		Duel.BreakEffect()
	end
	while sc do
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_EXTRA_SQUARE_MANA)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(cm.oval23)
		sc:RegisterEffect(e2)
		sc=sg:GetNext()
	end
end
function cm.otar31(e,c)
	return c:IsCode(18453009)
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c:CreateEffectRelation(e)
end
function cm.tfil4(c,e,tp)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and ((c:IsLoc("E") and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) or (not c:IsLoc("E") and Duel.GetLocCount(tp,"M")>0))
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil4,tp,"GE",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"GE")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil4,tp,"GE",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if c:IsRelateToEffect(e) then
		local e1=MakeEff(c,"FC","R")
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.ocon41)
		e1:SetOperation(cm.oop41)
		c:RegisterEffect(e1)
	end
end
function cm.ocon41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocCount(tp,"S")>0 and c:IsSSetable()
end
function cm.oop41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SSet(tp,c)
end