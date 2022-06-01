--제미니: 하늘이 무너진 듯한 슬픔도
local m=18453167
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnableReverseDualAttribute(c)
	local e1=MakeEff(c,"S","HM")
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(cm.con1)
	e1:SetValue(3)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetRange(LSTN("M"))
	e2:SetValue(200)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	e3:SetValue(2200)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_CHAINING)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetCountLimit(1,m)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"I","M")
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetCountLimit(1,m+1)
	WriteEff(e5,4,"N")
	WriteEff(e5,5,"CTO")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"FTo","G")
	e6:SetCode(EVENT_REMOVE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetCountLimit(1,m+2)
	WriteEff(e6,6,"NTO")
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"S")
	e7:SetCode(EFFECT_DEFENSE_ATTACK)
	e7:SetCondition(cm.con7)
	c:RegisterEffect(e7)
end
function cm.con1(e)
	local c=e:GetHandler()
	return not c:IsDualState()
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDisabled() or not c:IsDualState()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemove()
	end
	Duel.SOI(0,CATEGORY_REMOVE,c,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsControler(tp) and Duel.Remove(c,nil,REASON_EFFECT+REASON_TEMPORARY)>0 then
		aux.GeminiStarOperation(e,tp,1)
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(cm.ocon41)
		else
			e1:SetReset(RESET_PHASE+PHASE_END)
		end
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.oop41)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.ocon41(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.oop41(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end
function cm.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsDiscardable,tp,"H",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,Card.IsDiscardable,tp,"H",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tfil5(c)
	return c:IsSetCard("제미니:") and c:IsAbleToGrave() and not c:IsCode(m)
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil5,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.tfil5,tp,"D",0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		aux.GeminiStarOperation(e,tp,1)
	end
end
function cm.nfil6(c,tp)
	return c:IsPreviousLocation(LSTN("G")) and c:GetPreviousControler()==tp and c:IsSetCard("제미니:")
end
function cm.con6(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil6,1,nil,tp)
end
function cm.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		aux.GeminiStarOperation(e,tp,1)
	end
end
function cm.con7(e)
	local c=e:GetHandler()
	return c:IsDualState() and not c:IsDisabled()
end