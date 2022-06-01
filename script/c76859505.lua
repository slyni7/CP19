--모노크로니클 카시아
local m=76859505
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","M")
	e2:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetCountLimit(1,m+1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","M")
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetCountLimit(1,m+1)
	WriteEff(e4,3,"TO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FTo","M")
	e5:SetCode(EVENT_TO_HAND)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetCountLimit(1,m+2)
	WriteEff(e5,5,"NTO")
	c:RegisterEffect(e5)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil1(c)
	return c:IsSetCard(0x2c6) and c:IsType(TYPE_FIELD) and (c:IsFaceup() or not c:IsLoc("R"))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"DGR",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,0,tp,"DGR")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"DGR",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and Duel.SelectYesNo(tp,16*m) then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LSTN("F"),POS_FACEUP,true)
		end
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetDefense()<800 then
		return
	end
	if c:IsImmuneToEffect(re) then
		return
	end
	if rp==tp then
		return
	end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g<1 then
		return
	end
	if g:IsContains(c) then
		c:ReleaseEffectRelation(re)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-800)
		c:RegisterEffect(e1)
	end
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("GR") and chkc:IsAbleToDeck() and
			chkc:IsSetCard(0x2c6) and (chkc:IsLoc("G") or chkc:IsFaceup())
	end
	if chk==0 then
		return Duel.IEToDeckTarget(Card.IsSetCard,tp,"GR",0,1,nil,0x2c6) and
			Duel.IsPlayerCanDraw(tp,1)
	end
	local g=Duel.SToDeckTarget(tp,Card.IsSetCard,tp,"GR",0,1,3,nil,0x2c6)
	Duel.SOI(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoDeck(g,nil,0,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.nfil5(c,tp)
	return c:GetPreviousLocation()&LOCATION_DECK>0 and c:IsControler(tp)
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil5,1,nil,tp)
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMToHandCard(Card.IsSetCard,tp,"D",0,1,m,0x2c6)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SMAToHandCard(tp,Card.IsSetCard,tp,"D",0,1,1,m,0x2c6)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end