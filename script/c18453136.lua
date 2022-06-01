--스타피시 플러스
local m=18453136
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	cm.todeck_effect=e1
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1,m+1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tfil1(c,e,tp)
	return c:IsSetCard(0x2e3) and c:IsAbleToHand() and c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(cm.tfil1,tp,"D",0,nil)
	local mg=Duel.GMGroup(aux.TRUE,tp,"M",0,nil)
	local mc=mg:GetFirst()
	while mc do
		local og=mc:GetOverlayGroup()
		if og and #og>0 then
			local tg=og:Filter(cm.tfil1,nil)
			g:Merge(tg)
		end
		mc=mg:GetNext()
	end
	if chk==0 then
		return #g>0
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DX")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(cm.tfil1,tp,"D",0,nil)
	local mg=Duel.GMGroup(aux.TRUE,tp,"M",0,nil)
	local mc=mg:GetFirst()
	while mc do
		local og=mc:GetOverlayGroup()
		if og and #og>0 then
			local tg=og:Filter(cm.tfil1,nil)
			g:Merge(tg)
		end
		mc=mg:GetNext()
	end
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.tfil21(c)
	return c:IsSetCard(0x2e3) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tfil22(c)
	return c:IsRace(RACE_FISH) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GMGroup(cm.tfil21,tp,"D",0,nil)
	local mg=Duel.GMGroup(aux.TRUE,tp,"M",0,nil)
	local mc=mg:GetFirst()
	while mc do
		local og=mc:GetOverlayGroup()
		if og and #og>0 then
			local tg=og:Filter(cm.tfil21,nil)
			g:Merge(tg)
		end
		mc=mg:GetNext()
	end
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("M") and cm.tfil22(chkc)
	end
	if chk==0 then
		return #g>0 and Duel.IETarget(cm.tfil22,tp,"M",0,1,nil) and c:IsCanOverlay()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.STarget(tp,cm.tfil22,tp,"M",0,1,1,nil)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"DX")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GMGroup(cm.tfil21,tp,"D",0,nil)
	local mg=Duel.GMGroup(aux.TRUE,tp,"M",0,nil)
	local mc=mg:GetFirst()
	while mc do
		local og=mc:GetOverlayGroup()
		if og and #og>0 then
			local tg=og:Filter(cm.tfil21,nil)
			g:Merge(tg)
		end
		mc=mg:GetNext()
	end
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		if c:IsRelateToEffect(e) then
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_XYZ) then
				Duel.BreakEffect()
				Duel.Overlay(tc,Group.FromCards(c))
			end
		end
	end
end