--举府胶敲肺傈
local m=18453009
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCondition(cm.con2)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FTf","M")
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	WriteEff(e5,5,"O")
	c:RegisterEffect(e5)
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_WIND,ATTRIBUTE_WATER,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.con1(e,c,minc)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return minc<1 and c:IsLevelAbove(5) and Duel.GetLocCount(tp,"M")>0
end
function cm.con2(e)
	local c=e:GetHandler()
	local sumtype=c:GetSummonType()
	return sumtype&SUMMON_TYPE_NORMAL==SUMMON_TYPE_NORMAL and sumtype&SUMMON_TYPE_ADVANCE~=SUMMON_TYPE_ADVANCE
end
function cm.val2(e,c)
	return #c:GetSquareMana()*200
end
function cm.tfil3(c)
	return c:IsSetCard("举府胶") and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local t=c:GetSquareMana()
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(cm.oval51(t))
		c:RegisterEffect(e1)
	end
end
function cm.oval51(t)
	return function(e,c)
		return table.unpack(t)
	end
end