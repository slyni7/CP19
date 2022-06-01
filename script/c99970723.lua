--[ Refined Spellstone ]
local m=99970723
local cm=_G["c"..m]
function cm.initial_effect(c)

	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,aux.FBF(Card.IsModuleSetCard,0xd6b),nil,1,99,nil)
	YuL.NoMat(c,"M")
	
	--장착
	local e1=MakeEff(c,"STo")
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(spinel.delay)
	e1:SetCL(1,m)
	e1:SetCondition(spinel.stypecon(SUMT_M))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

	--샐비지
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(spinel.delay)
	e3:SetCondition(aux.PreOnfield)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	
end

--장착
function cm.op1fil(c)
	return c:IsSetCard(0xd6b) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.op1fil2(c,ec)
	return c:IsSetCard(0xd6c) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.op1fil2,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsFacedown() or not c:IsRelateToEffect(e) or ft<=0 then return end
	local ct=Duel.GetMatchingGroupCount(cm.op1fil,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.op1fil2,tp,LOCATION_GRAVE,0,1,math.min(ft,ct),nil,e:GetHandler())
	for tc in aux.Next(g) do
		Duel.Equip(tp,tc,c)
	end
end

--샐비지
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function cm.tar3fil(c)
	return c:IsAbleToHand() and ((c:IsSetCard(0xd6b) and c:IsType(TYPE_MONSTER)) or c:IsCode(m+7))
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar3fil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tar3fil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
