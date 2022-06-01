--아로할로위즈 세레나
local m=18452733
local cm=_G["c"..m]
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2d2),
		cm.pfil1,true)
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetTR("M","M")
	e1:SetValue(POS_FACEUP_DEFENSE)
	e1:SetTarget(cm.tar1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_SELF_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTR("M","M")
	e2:SetLabelObject(e1)
	e2:SetTarget(cm.tar2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_TOHAND)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function cm.pfil1(c)
	return c:IsFusionAttribute(ATTRIBUTE_EARTH) or c:IsHasEffect(18452720)
end
function cm.tar1(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and not c:IsSetCard(0x2d2)
		and c:IsAttackPos()
end
function cm.tar2(e,c)
	local eset={c:IsHasEffect(EFFECT_SET_POSITION)}
	local pe=e:GetLabelObject()
	for _,te in ipairs(eset) do
		if pe==te and c:IsAttackPos() and not c:IsCanChangePosition() then
			return true
		end
	end
	return false
end
function cm.tfil4(c)
	return c:IsSetCard(0x2d2) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return cm.tfil4(chkc) and chkc:IsAbleToHand() and chkc:IsControler(tp)
			and chkc:IsLoc("R")
	end
	if chk==0 then
		return Duel.IEToHandTarget(cm.tfil4,tp,"R",0,1,nil)
	end
	local g=Duel.SAToHandTarget(tp,cm.tfil4,tp,"R",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end