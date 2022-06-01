--클래식 메모리즈 - 쿄우
local m=76859925
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2c0),1,1,aux.NonTuner(Card.IsSetCard,0x2c0),1,99)
	c:EnableReviveLimit()
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,m)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCL(1,m+1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e3=MakeEff(c,"FTf","M")
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCL(1,m+2)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCL(1,m+3)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function cm.cfil1(c,tp)
	if c:IsLoc("H") then
		return c:IsSetCard(0x2c0) and c:IsDiscardable() and c:IsType(TYPE_MONSTER)
	else
		return c:IsSetCard(0x2c0) and Duel.IsPlayerAffectedByEffect(tp,76859930) and c:IsReleasable()
	end
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.cfil1,tp,"H","M",1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,cm.cfil1,tp,"H","M",1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsLoc("H") then
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	else
		Duel.Release(g,REASON_COST)
	end
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LSTN("H"))
	if chk==0 then
		return #g>0
	end
	Duel.SOI(0,CATEGORY_DESTROY,nil,1,1-tp,"H")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LSTN("H"))
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end
function cm.cfil2(c)
	return c:IsSetCard(0x2c0) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.cfil2,tp,"HG",0,2,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,cm.cfil2,tp,"HG",0,2,2,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function cm.tfil4(c)
	return c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil4,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil4,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end