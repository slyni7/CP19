--IB: 개혁의 흑마 벨디누스
local m=99970449
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Imaginary Beast
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0xe02))

	--공수 감소
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e11)
	
	--이중 공격
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	--파괴 내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(cm.valcon)
	c:RegisterEffect(e3)
	
	--자가 회수
	local e4=MakeEff(c,"STo")
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(spinel.delay)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)

end

--파괴 내성
function cm.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end

--자가 회수
function cm.thfilter(c)
	return c:IsSetCard(0xe02) and c:IsAbleToRemoveAsCost()
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
