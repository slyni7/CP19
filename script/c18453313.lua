--유키토키사키
local m=18453313
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsActiveType(TYPE_MONSTER) then
		return false
	end
	local ex,tg=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	local rc=re:GetHandler()
	if rc:IsCode(38814750) then
		return true
	end
	return ex and tg and tg:IsContains(rc)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_YUKITOKISAKI)
	e1:SetReset(RESET_CHAIN)
	e1:SetLabelObject(re)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTR(0,1)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetReset(RESET_CHAIN)
	e2:SetLabel(ev)
	e2:SetLabelObject(e1)
	e2:SetCondition(cm.ocon12)
	e2:SetOperation(cm.oop12)
	Duel.RegisterEffect(e2,tp)
end
function cm.ocon12(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local se=te:GetLabelObject()
	local sc=se:GetHandler()
	return eg:IsContains(sc)
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local cc=e:GetLabel()
	if Duel.NegateEffect(cc) then
		te:SetLabel(1)
	end
end