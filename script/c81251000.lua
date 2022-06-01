--사이돌 페어리테일러
local m=81251000
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tar2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DICE)
	e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.tar3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
cm.toss_dice=true
function cm.val1(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_DICE) and re:GetHandler():IsSetCard(0xc82)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	local t={}
	for i=1,6 do
		t[i]=i
	end
	local a=Duel.AnnounceNumber(tp,table.unpack(t))
	e:SetLabel(a)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TOSS_DICE_NEGATE)
		e1:SetReset(RESET_CHAIN)
		e1:SetLabelObject(re)
		e1:SetLabel(e:GetLabel())
		e1:SetCondition(cm.ocon21)
		e1:SetOperation(cm.oop21)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.ocon21(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function cm.oop21(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local ct=bit.band(ev,0xff)+bit.rshift(ev,16)
	for i=1,ct do
		t[i]=e:GetLabel()
	end
	Duel.SetDiceResult(table.unpack(t))
	e:Reset()
end
function cm.tfil3(c)
	return c:IsSetCard(0xc82) and (c:IsAbleToGrave() or c:IsAbleToHand())
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil3,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function cm.ofil31(c)
	return c:IsSetCard(0xc82) and c:IsAbleToGrave()
end
function cm.ofil32(c)
	return c:IsSetCard(0xc82) and c:IsAbleToHand()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==3 or dc==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.ofil31,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	elseif dc==2 or dc==4 or dc==6 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.ofil32,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end