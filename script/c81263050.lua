--궤룡 라케리스
local m=81263050
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,cm.pfil1,nil,1,5,nil)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetCountLimit(1,m)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
end
function cm.pfil1(c)
	return c:IsSetCard(0xc95) and c:IsType(TYPE_MODULE) and not c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_MODULE)
end
function cm.tfil1(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(cm.tfil1,tp,0,"O",nil)
	if chk==0 then
		return #g>0
	end
	Duel.SOI(0,CATEGORY_DISABLE,g,#g,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GMGroup(cm.tfil1,tp,0,"O",nil)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=MakeEff(c,"S")
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local sg=Duel.GMGroup(Card.IsType,tp,0,"MG",nil,TYPE_MONSTER)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(#sg*100)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_MODULE) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.tfil4(c)
	return (c:IsRace(RACE_WYRM) or c:GetType()&TYPE_SPELL+TYPE_EQUIP==TYPE_SPELL+TYPE_EQUIP) and c:IsAbleToHand()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.tfil4,tp,"G",0,1,c)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"G")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil4,tp,"G",0,1,1,c)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end