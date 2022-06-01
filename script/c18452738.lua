--아로할로위즈 아나스타샤
local m=18452738
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2d2),
		cm.pfil1,true)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","M")
	e2:SetCode(EVENT_CHAINING)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTR(1,0)
	e3:SetCondition(cm.con3)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCondition(cm.con5)
	e5:SetTR(0,1)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"STo")
	e6:SetCode(EVENT_REMOVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCategory(CATEGORY_TOHAND)
	WriteEff(e6,6,"TO")
	c:RegisterEffect(e6)
end
function cm.pfil1(c)
	return c:IsFusionAttribute(ATTRIBUTE_WATER) or c:IsHasEffect(18452720)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER) then
		return
	end
	c:RegisterFlagEffect(m,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.con3(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)>0
end
function cm.val3(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsNotImmuneToEffect(e)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) then
		return
	end
	c:RegisterFlagEffect(m+1,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.con5(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(m+1)>0
end
function cm.tfil6(c)
	return c:IsSetCard(0x2d2) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.tar6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return cm.tfil6(chkc) and chkc:IsAbleToHand() and chkc:IsControler(tp)
			and chkc:IsLoc("R")
	end
	if chk==0 then
		return Duel.IEToHandTarget(cm.tfil6,tp,"R",0,1,nil)
	end
	local g=Duel.SAToHandTarget(tp,cm.tfil6,tp,"R",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end