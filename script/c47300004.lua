--트랜캐스터 콰트
local m=47300004
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)

	--give mana
	local e99=Effect.CreateEffect(c)
	e99:SetDescription(aux.Stringid(m,1))
	e99:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e99:SetType(EFFECT_TYPE_QUICK_O)
	e99:SetRange(LOCATION_GRAVE)
	e99:SetCode(EVENT_FREE_CHAIN)
	e99:SetHintTiming(0,TIMING_END_PHASE)
	e99:SetCountLimit(1,m+1000)
	e99:SetCost(aux.bfgcost)
	e99:SetTarget(cm.gmtg)
	e99:SetOperation(cm.gmop)
	c:RegisterEffect(e99)

end

cm.square_mana={ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT}
cm.custom_type=CUSTOMTYPE_SQUARE

function cm.thfilter(c,e,tp)
	return c:IsSetCard(0xe3e) and c:IsAbleToHand() and not c:IsCode(m)and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.thfilter(chkc,e,tp) end

	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)

	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end



function cm.gmfilter(c)
	return c:IsSetCard(0xe3e) and c:GetExactManaCount(0x0)>=3
end
function cm.gmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.gmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.gmfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,cm.gmfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.gmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetExactManaCount(0x0)>=3 then

		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(cm.oval1)
		tc:RegisterEffect(e1)

		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_SQUARE_MANA_DECLINE)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		e2:SetValue(cm.tval1)
		tc:RegisterEffect(e2)

	end
end

function cm.oval1(e,c)
	return ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT
end
function cm.tval1(e,c)
	return 0x0,0x0,0x0
end
