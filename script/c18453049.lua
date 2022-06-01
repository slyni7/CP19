--막장기관차 미코이치
local m=18453049
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"SR")
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTR("M",0)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STf")
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_DRAW)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
cm.square_mana={ATTRIBUTE_DARK,ATTRIBUTE_FIRE,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.tfil1(c)
	return c:IsFaceup() and c:IsCode(m) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local g=Duel.GMGroup(cm.tfil1,tp,"O",0,nil)
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,#g+1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		local g=Duel.GMGroup(cm.tfil1,tp,"O",0,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,#g,REASON_EFFECT)
		end
	end
end
function cm.val2(e,c,rc)
	return 0xa0000+c:GetLevel()
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LSTN("O")) or (c:IsReason(REASON_COST) and re:IsActivated()
		and re:IsActiveType(TYPE_XYZ) and c:IsPreviousLocation(LSTN("X")))
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end