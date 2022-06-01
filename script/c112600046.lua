--CytusII Lv.15 Fur War, Pur War
function c112600046.initial_effect(c)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(2000)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(2000)
	c:RegisterEffect(e3)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112600046,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_ONFIELD)
	e1:SetTarget(c112600046.mattg)
	e1:SetOperation(c112600046.matop)
	c:RegisterEffect(e1)
	--hand link
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e4:SetRange(LOCATION_HAND)
	e4:SetValue(c112600046.matval)
	c:RegisterEffect(e4)
	--atk / def up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e5:SetCondition(c112600046.atkcon)
	e5:SetOperation(c112600046.atkop)
	c:RegisterEffect(e5)
end
function c112600046.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe7e) and c:IsType(TYPE_XYZ)
end
function c112600046.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c112600046.matfilter(chkc) end
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingTarget(c112600046.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c112600046.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c112600046.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c112600046.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_PSYCHO)
end
function c112600046.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(112600046)
end
function c112600046.matval(e,c,mg)
	return c:IsSetCard(0xe7e) and mg:IsExists(c112600046.mfilter,1,nil) and not mg:IsExists(c112600046.exmfilter,1,nil)
end
function c112600046.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end
function c112600046.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(2000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	rc:RegisterEffect(e2,true)
end