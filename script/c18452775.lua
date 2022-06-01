--아이네 클라이네
local m=18452775
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0
		and #Duel.GMGroup(Card.IsType,tp,0,"G",nil,TYPE_MONSTER)>=#Duel.GMGroup(Card.IsType,tp,"G",0,nil,TYPE_MONSTER)
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
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLoc("G") and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	if chk==0 then
		return Duel.IETarget(Card.IsCanBeSpecialSummoned,tp,0,"G",1,nil,e,0,tp,false,false)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,Card.IsCanBeSpecialSummoned,tp,0,"G",1,1,nil,e,0,tp,false,false)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end