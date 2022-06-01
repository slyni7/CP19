--Stellar Resound
local m=99970408
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--장착
	YuL.Equip(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0xe1b))

	--효과 부여 ●효과 파괴 내성 부여
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(cm.indtg)
	e1:SetValue(1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e0:SetTarget(cm.eqtg)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	
	--자가 특수 소환
	local e2=MakeEff(c,"I","S")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	
	--장착
	local e3=MakeEff(c,"Qo","M")
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetCountLimit(1)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	
end

--효과 부여 ●효과 파괴 내성 부여
function cm.eqtg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function cm.indtg(e,c)
	return c:IsSetCard(0xe1b) and c:IsType(TYPE_EQUIP) and c:IsFaceup() and e:GetHandler():GetEquipGroup():IsContains(c)
end

--자가 특수 소환
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function cm.cfilter(c)
	return c:IsSetCard(0xe1b) and c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LSTN("M"))>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe1b,TYPE_MONSTER+TYPE_EFFECT,1000,1000,7,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LSTN("M"))<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe1b,TYPE_MONSTER+TYPE_EFFECT,1000,1000,7,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,1,tp,tp,true,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end

--장착
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function cm.filter(c,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Equip(tp,tc,c)
	end
end
