--데스티니 체어
local m=18452982
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EVENT_ADJUST)
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCondition(cm.con3)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FC","M")
	e4:SetCode(EVENT_ADJUST)
	e4:SetLabelObject(e3)
	WriteEff(e4,4,"O")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"S")
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetValue(cm.val5)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"S")
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetCondition(cm.con6)
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"F","M")
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetTR(0,"M")
	e7:SetValue(cm.val7)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)
	local e9=MakeEff(c,"S")
	e9:SetCode(EFFECT_PIERCE)
	e9:SetCondition(cm.con9)
	c:RegisterEffect(e9)
end
cm.square_mana={0x0}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)<1
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
	Duel.Hint(HINT_CARD,0,m)
	local atk=YuL.random(0,4000)
	Duel.Hint(HINT_NUMBER,tp,atk)
	Duel.Hint(HINT_NUMBER,1-tp,atk)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
	local ct=math.floor(atk/1000)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(ct)
	c:RegisterEffect(e2)
	for i=1,ct do
		local dc=Duel.TossDice(tp,1)
		local e3=MakeEff(c,"S")
		e3:SetCode(EFFECT_EXTRA_SQUARE_MANA)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetLabel(1<<(dc-1))
		e3:SetValue(cm.oval13)
		c:RegisterEffect(e3)
	end
end
function cm.oval13(e,c)
	return e:GetLabel()
end
function cm.val2(e,c)
	return c:GetManaCount(ATTRIBUTE_FIRE)*1000
end
function cm.con3(e)
	return e:GetLabel()>0
end
function cm.val3(e,re,r,rp)
	return r&(REASON_BATTLE+REASON_EFFECT)>0
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetManaCount(ATTRIBUTE_EARTH)
	local te=e:GetLabelObject()
	te:SetCountLimit(ct)
	te:SetLabel(ct)
end
function cm.val5(e,c)
	return c:GetManaCount(ATTRIBUTE_LIGHT)
end
function cm.con6(e)
	local c=e:GetHandler()
	return c:GetManaCount(ATTRIBUTE_WIND)>0
end
function cm.val7(e,c)
	return e:GetHandler():GetManaCount(ATTRIBUTE_WATER)*-1000
end
function cm.con9(e)
	return e:GetHandler():GetManaCount(ATTRIBUTE_DARK)>0
end