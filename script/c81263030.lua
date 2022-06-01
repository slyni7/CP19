--궤룡 듀에메스
local m=81263030
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,cm.pfil1,aux.FilterBoolFunction(Card.IsCode,81263060),1,5,nil)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_DESTROY)
	e1:SetCountLimit(1)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCountLimit(1,m+1)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
function cm.pfil1(c)
	return c:IsSetCard(0xc95) and c:IsType(TYPE_MODULE) and not c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return ep~=tp and not c:IsStatus(STATUS_BATTLE_DESTROYED) and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or not rc:IsType(TYPE_MODULE))
		and Duel.IsChainNegatable(ev)
end
function cm.tfil1(c)
	return c:IsType(TYPE_EQUIP) and (c:IsFaceup() or c:IsLoc("H"))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"HS",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SOI(0,CATEGORY_DESTROY,nil,1,tp,"HS")
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.SOI(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SMCard(tp,cm.tfil1,tp,"HS",0,1,1,nil)
			if #g>0 then
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_MODULE) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.tfil3(c)
	return (c:IsRace(RACE_WYRM) or c:GetType()&TYPE_SPELL+TYPE_EQUIP==TYPE_SPELL+TYPE_EQUIP) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"G",0,1,c)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"G")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"G",0,1,1,c)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end