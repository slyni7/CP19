--아로할로위즈 네레이아
local m=18452735
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2d2),
		cm.pfil1,true)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_REMOVE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	WriteEff(e3,2,"C")
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_TOHAND)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function cm.pfil1(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) or c:IsHasEffect(18452720)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMRemoveCard(Card.IsSetCard,tp,"D",0,1,nil,0x2d2)
	end
	Duel.SOI(0,CATEGORY_REMOVE,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SMRemoveCard(tp,Card.IsSetCard,tp,"D",0,1,1,nil,0x2d2)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and not c:IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsChainNegatable(ev)
end
function cm.cfil2(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x2d2)
		and c:IsAbleToRemoveAsCost()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMRemoveACCard(cm.cfil2,tp,"HO",0,1,nil)
	end
	local g=Duel.SMRemoveACCard(tp,cm.cfil2,tp,"HO",0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function cm.tfil3(c)
	return c:IsControlerCanBeChanged()
		and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_XYZ+TYPE_PENDULUM)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(cm.tfil3,tp,0,"M",nil)
	if chk==0 then
		return #g>0
	end
	Duel.SOI(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SMCard(tp,cm.tfil3,tp,0,"M",1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.GetControl(tc,tp)
	end
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