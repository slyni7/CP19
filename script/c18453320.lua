--아포칼립스트 마오카이
local m=18453320
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","H")
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STf")
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
end
function cm.nfil1(c,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.IEMCard(cm.nfil1,tp,0,"M",1,nil,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SMCard(tp,cm.nfil1,tp,0,"M",1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function cm.con2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0 and Duel.GetFieldGroupCount(tp,LSTN("M"),0)<=Duel.GetFieldGroupCount(tp,0,LSTN("M"))
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local c=e:GetHandler()
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,c:GetOwner(),"D")
end
function cm.ofil3(c,e,op,tp)
	return c:IsSetCard(0x2ee) and c:IsCanBeSpecialSummoned(e,0,op,false,false,POS_FACEUP,1-tp)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(1-tp,"M")<1 then
		return
	end
	local c=e:GetHandler()
	local op=c:GetOwner()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(op,cm.ofil3,op,"D",0,1,1,nil,e,op,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,op,1-tp,false,false,POS_FACEUP)
	end
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOwner()==tp
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local b=fc and fc:IsHasEffect(18453321,tp) and fc:IsAbleToHandAsCost()
	if chk==0 then
		return (c:IsAbleToHandAsCost() and Duel.GetMZoneCount(tp,c,tp)>0) or b
	end
	if b and (not (c:IsAbleToHandAsCost() and Duel.GetMZoneCount(tp,c,tp)>0) or Duel.SelectYesNo(tp,aux.Stringid(18453321,0))) then
		local te=fc:IsHasEffect(18453321,tp)
		te:UseCountLimit(tp)
		Duel.SendtoHand(fc,nil,REASON_COST)
	else
		Duel.SendtoHand(c,nil,REASON_COST)
	end
end
function cm.tfil4(c,e,tp)
	return c:IsSetCard(0x2ee) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil4,tp,"H",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"H")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil4,tp,"H",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end