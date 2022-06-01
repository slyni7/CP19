--T. Enchanter: 9
function c99970029.initial_effect(c)

	--엑시즈 소환
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd32),4,2,c99970029.ovfilter,aux.Stringid(99970029,0),2,c99970029.xyzop)
	c:EnableReviveLimit()
	
	--소환 제약
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c99970029.sumlimit)
	c:RegisterEffect(e1)

	--오버레이
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99970029,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c99970029.mtcost)
	e3:SetTarget(c99970029.mttg)
	e3:SetOperation(c99970029.mtop)
	c:RegisterEffect(e3,false,1)
	
end

--엑시즈 소환
function c99970029.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd32) and not c:IsCode(99970029) and c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_WATER)
end
function c99970029.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,99970029)==0 end
	Duel.RegisterFlagEffect(tp,99970029,RESET_PHASE+PHASE_END,0,1)
	return true
end

--소환 제약
function c99970029.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsAttribute(e:GetHandler():GetAttribute())
end

--오버레이
function c99970029.mtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99970029.mtfilter(c)
	return c:IsSetCard(0xd33)
end
function c99970029.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99970029.mtfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99970029.mtfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=Duel.SelectTarget(tp,c99970029.mtfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg,1,0,0)
end
function c99970029.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
