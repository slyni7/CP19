--¿å¸ÁÀÇ ³îºÎ
local m=18453233
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCost(cm.cost1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","H")
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,m)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCL(1,m+1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","M")
	e4:SetCode(EFFECT_GREED_OLDER)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTR(1,0)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.afil1)
end
function cm.afil1(c)
	return not (c:GetSummonLocation()==LSTN("E") and not c:IsCustomType(CUSTOMTYPE_DELIGHT))
end
function cm.cost1(e,c,tp)
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.otar11)
	Duel.RegisterEffect(e1,tp)
end
function cm.otar11(e,c)
	return not c:IsCustomType(CUSTOMTYPE_DELIGHT) and c:IsLocation(LSTN("E"))
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
	end
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsAbleToRemoveAsCost,tp,"H",0,1,nil,POS_FACEDOWN)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,Card.IsAbleToRemoveAsCost,tp,"H",0,1,1,nil,POS_FACEDOWN)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
end