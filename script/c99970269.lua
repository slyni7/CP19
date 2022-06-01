--La Biblioteca de Babel
local m=99970269
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--발동
	YuL.Activate(c)
	
	--내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)

	--La Biblioteca de Babel
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m)
	e3:SetCondition(YuL.turn(0))
	e3:SetOperation(cm.thop)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e3)

	--샐비지 + 제외
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_RECOVER)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.activate)
	c:RegisterEffect(e4)

end

--내성
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

--La Biblioteca de Babel
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local babel=YuL.random(99970262,99970270)
	local token=Duel.CreateToken(tp,babel)
	Duel.SendtoHand(token,nil,REASON_RULE)
	Duel.ConfirmCards(1-tp,token)
	if babel==m then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end

--샐비지 + 제외
function cm.filter(c,e,tp)
	return c:IsSetCard(0xe03) and c:IsType(TYPE_TRAP) and not c:IsCode(m) and c:IsAbleToRemove()
end
function cm.filter2(c)
	return c:IsSetCard(0xd3e) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local tc=g:FilterSelect(1-tp,cm.filter,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		g:RemoveCard(tc)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter2),tp,LOCATION_GRAVE,0,nil)
		if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
