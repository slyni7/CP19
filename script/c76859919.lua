--클래식 메모리얼 - 사기리
local m=76859919
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","M")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCL(1)
	WriteEff(e3,3,"CO")
	WriteEff(e3,2,"T")
	c:RegisterEffect(e3)
end
function cm.cfil1(c,tp)
	if c:IsLoc("H") then
		return c:IsDiscardable()
	elseif c:IsControler(1-tp) then
		return Duel.IsPlayerAffectedByEffect(tp,76859930) and c:IsReleasable()
	else
		return Duel.GetFlagEffect(tp,m)==0 and c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT==0 then
		return false
	end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x2c0) and re:IsActiveType(TYPE_MONSTER)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.cfil1,tp,"HD","M",1,c,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,cm.cfil1,tp,"HD","M",1,1,c,tp)
	local tc=g:GetFirst()
	if tc:IsLoc("H") then
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	elseif tc:IsControler(1-tp) then
		Duel.Release(g,REASON_COST)
	else
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	end
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsRelateToEffect(e)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function cm.cfil2(c)
	return c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil2,tp,"D",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SMCard(tp,cm.cfil2,tp,"D",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
end
function cm.tfil2(c,e,tp)
	return c:IsSetCard(0x2c0) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=MakeEff(c,"F")
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_TO_HAND)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.oop22)
	Duel.RegisterEffect(e2,tp)
end
function cm.oofil22(c,e,tp)
	return c:IsControler(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x2c0) and c:IsLoc("H")
		and c:GetPreviousLocation()==LSTN("D")
end
function cm.oop22(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	local g=eg:Filter(cm.oofil22,nil,e,tp)
	if #g==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,0,1,nil)
	if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_CARD,0,m)
		local te=e:GetLabelObject()
		te:Reset()
		e:Reset()
	end
end
function cm.cfil3(c,tp)
	if c:IsLoc("H") then
		return c:IsDiscardable()
	elseif c:IsControler(1-tp) then
		return Duel.IsPlayerAffectedByEffect(tp,76859930) and c:IsReleasable()
	end
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.cfil3,tp,"HD","M",1,c,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,cm.cfil3,tp,"HD","M",1,1,c,tp)
	local tc=g:GetFirst()
	if tc:IsLoc("H") then
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	elseif tc:IsControler(1-tp) then
		Duel.Release(g,REASON_COST)
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end