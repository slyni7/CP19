--Orcatia Poesia
local m=99970347
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT))
	
	--공수 증가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	
	--장착
	local e3=MakeEff(c,"Qo","S")
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)

end

--장착
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabelObject(e:GetHandler():GetEquipTarget())
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.eqfil(c,ec)
	return c:IsSetCard(0xe10) and c:IsType(TYPE_UNION) and c:CheckEquipTarget(ec) and aux.CheckUnionEquip(c,ec)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.eqfil,tp,LOCATION_DECK,0,1,nil,tc) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.eqfil,tp,LOCATION_DECK,0,1,1,nil,tc)
	local ec=g:GetFirst()
	if ec and aux.CheckUnionEquip(ec,tc) and Duel.Equip(tp,ec,tc) then
		aux.SetUnionState(ec)
	end
end
