--리가카-희도섬
function c18452892.initial_effect(c)
	c:SetSPSummonOnce(18452892)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c18452892.matfilter,1,1)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c18452892.atkval)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18452892,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c18452892.thtg)
	e3:SetOperation(c18452892.thop)
	c:RegisterEffect(e3)
end
function c18452892.matfilter(c)
	return c:IsLinkSetCard(0x12da) and not c:IsLinkAttribute(ATTRIBUTE_FIRE)
end
function c18452892.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_TRAP)*100
end
function c18452892.thfilter(c,tp)
	return c:IsSetCard(0x2da) and c:IsType(TYPE_TRAP) and (c:IsAbleToHand()
		or (c:IsSSetable() and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)))
end
function c18452892.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c18452892.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18452892.thfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c18452892.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c18452892.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local off=1
		local ops={}
		local opval={}
		if tc:IsAbleToHand() then
			ops[off]=aux.Stringid(18452892,1)
			opval[off-1]=1
			off=off+1
		end
		if tc:IsSSetable() and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
			ops[off]=aux.Stringid(18452892,2)
			opval[off-1]=2
			off=off+1
		end
		if off==1 then
			return
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		elseif opval[op]==2 then
			Duel.SSet(tp,tc)
		end
	end
end
