--제로 슬라이더
local m=18453048
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,">",cm.pfun1,aux.TRUE,aux.TRUE)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetCountLimit(1,m+1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT}
cm.custom_type=CUSTOMTYPE_SQUARE
cm.CardType_Order=true
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ORDER) or c:IsSummonType(SUMMON_TYPE_ORDER_L) or c:IsSummonType(SUMMON_TYPE_ORDER_R)
end
function cm.tfil1(c)
	return c:IsCode(18452796) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cfil2(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil2,tp,"O",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SMCard(tp,cm.cfil2,tp,"O",0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsCode(18452796) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,1)
	if e:GetLabel()>0 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
		Duel.SOI(0,CATEGORY_TOHAND,nil,0,PLAYER_ALL,"OG")
	else
		e:SetCategory(CATEGORY_DRAW)
	end
end
function cm.ofil2(c)
	return (not c:IsLocation(LOCATION_GRAVE) or (c:GetAttack()==0 and c:IsType(TYPE_MONSTER))) and c:IsAbleToHand()
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 and e:GetLabel()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SMCard(tp,cm.ofil2,tp,"G","M",0,1,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end