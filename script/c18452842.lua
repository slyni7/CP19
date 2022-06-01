--파이네 클라이네
local m=18452842
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,cm.pfil1)
	aux.AddCodeList(c,CARD_EINE_KLEINE)
	local e1=MakeEff(c,"S","MG")
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(CARD_EINE_KLEINE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.pfil1(c,fc,sub,mg,sg)
	if c:IsType(TYPE_FUSION) then
		return false
	end
	return c:IsFusionCode(CARD_EINE_KLEINE) or (sub and c:CheckFusionSubstitute(fc))
end
function cm.cfil21(c)
	return c:IsCode(CARD_EINE_KLEINE) and c:IsAbleToRemoveAsCost()
end
function cm.cfil22(c,tp)
	return Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp):Filter(Card.IsCode,nil,CARD_EINE_KLEINE)
	if c:IsHasEffect(EFFECT_EINE_KLEINE) then
		local rg=Duel.GMGroup(cm.cfil21,tp,"G",0,nil)
		g:Merge(rg)
	end
	if chk==0 then
		return g:IsExists(cm.cfil22,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tg=g:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if tc:IsLoc("G") then
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
		local te=c:IsHasEffect(EFFECT_EINE_KLEINE)
		te:UseCountLimit(tp)
	else
		Duel.Release(tg,REASON_COST)
	end
end
function cm.tfil2(c,e,tp)
	return c:IsSetCard("클라이네") and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end