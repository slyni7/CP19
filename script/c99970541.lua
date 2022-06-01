--[The Shard of Dream]
local m=99970541
local cm=_G["c"..m]
function cm.initial_effect(c)

	--스퀘어
	aux.AddSquareProcedure(c)

	--●샐비지
	local e1=MakeEff(c,"I","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCL(1)
	WriteEff(e1,1,"CTO")
	e1:SetCondition(spinel.stypecon(SUMMON_TYPE_SQUARE))
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_MATERIAL)
	WriteEff(e0,0,"NO")
	c:RegisterEffect(e0)
	
	--서치
	local e2=MakeEff(c,"STo")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(spinel.delay)
	e2:SetCondition(aux.PreOnfield)
	e2:SetCL(1,m)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
end

--스퀘어
cm.square_mana={ATTRIBUTE_WATER,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE

--●샐비지
function cm.thcofilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(cm.filter1,tp,LOCATION_GRAVE,0,1,c)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thcofilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.thcofilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.filter1(c)
	return c:IsSetCard(0xd31) and c:IsAbleToHand() and not c:IsCode(99970541)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.filter1(c) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function cm.con0(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO or r==REASON_SQUARE
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=MakeEff(rc,"I","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCL(1)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_TYPE)
		e0:SetValue(TYPE_EFFECT)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		rc:RegisterEffect(e0,true)
	end
end

--서치
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.filter(c)
	return c:IsSetCard(0xd31)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 then
		local sg=g:Filter(cm.filter,nil)
		if #sg>0 then
			local ct=#sg if ct>2 then ct=2 end
			local hg=sg:Select(tp,1,ct,nil)
			if hg:GetFirst():IsAbleToHand() then
				Duel.SendtoHand(hg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-p,hg)
				Duel.ShuffleHand(p)
			else
				Duel.SendtoGrave(hg,REASON_EFFECT)
			end
		end
		Duel.ShuffleDeck(p)
	end
end
