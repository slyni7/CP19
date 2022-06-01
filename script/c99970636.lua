--[ hololive 1st Gen ]
local m=99970636
local cm=_G["c"..m]
function cm.initial_effect(c)

	--하아쨔마 쿠킹!
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)

	--샐비지
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_TOHAND)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	
end

--하아쨔마 쿠킹!
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(99970633)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.IsChainDisablable(0) then
		if Duel.CheckLPCost(1-tp,1000) and Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
			Duel.PayLPCost(1-tp,1000)
			Duel.NegateEffect(0)
			return
		end
	end
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

--샐비지
function cm.cfil2(c,tp)
	return c:IsFaceup() and c:IsCode(99970633)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local xg=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(cm.cfil2,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do xg:Merge(tc:GetOverlayGroup()) end
	if #xg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local sg=xg:Select(tp,2,2,nil)
		Duel.SendtoGrave(sg,REASON_COST)
	end
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
