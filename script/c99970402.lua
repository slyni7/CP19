--Glow Resound
local m=99970402
local cm=_G["c"..m]
function cm.initial_effect(c)

	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,aux.FilterBoolFunction(Card.IsModuleRace,RACE_FAIRY),aux.FilterBoolFunction(Card.IsModuleSetCard,0xe1b),1,99,nil)

	--공수 증가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cm.val)
	c:RegisterEffect(e1)
	
	--덤핑
	local e2=MakeEff(c,"STo")
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetProperty(spinel.delay)
	e2:SetCode(EVENT_DESTROYED)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

--공수 증가
function cm.adfil(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(cm.adfil,0,LOCATION_SZONE,LOCATION_SZONE,c)*300
end

--덤핑
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function cm.tgfilter(c)
	return c:IsSetCard(0xe1b) and c:IsType(TYPE_EQUIP) and c:IsAbleToGrave()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
