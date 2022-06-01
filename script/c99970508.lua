--[Forest]
local m=99970508
local cm=_G["c"..m]
function cm.initial_effect(c)

	--서치 / 카운터 / 컨트롤
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COUNTER+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,m+YuL.O)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

end

--서치 / 카운터 / 컨트롤
function cm.filter(c)
	return c:IsFaceup() and c:IsCode(99970501)
end
function cm.thfil(c)
	return c:IsCode(m) and c:IsAbleToHand()
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil):GetCounter(0x1052)
	if chk==0 then return (ct<=2 and Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK,0,1,nil))
		or (ct<=7 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,0,1,nil))
		or (ct>=8 and Duel.IsExistingMatchingCard(cm.ctfilter,tp,0,LOCATION_MZONE,1,nil)) end
	if ct<=2 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil):GetCounter(0x1052)
	--서치
	local tc1=Duel.GetFirstMatchingCard(cm.thfil,tp,LOCATION_DECK,0,nil)
	if ct<=2 and tc1 then
		Duel.SendtoHand(tc1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc1)
	end
	--카운터
	local g2=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	if ct<=7 and g2:GetCount()>0 then
		local tc2=g2:GetFirst()
		while tc2 do
			tc2:AddCounter(0x1052,2,REASON_EFFECT)
			tc2=g2:GetNext()
		end
	end
	--컨트롤
	local g3=Duel.GetMatchingGroup(cm.ctfilter,tp,0,LOCATION_MZONE,1,nil)
	if ct>=8 and g3:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local tc3=g3:Select(tp,1,1,nil)
		Duel.GetControl(tc3,tp)
	end
end
