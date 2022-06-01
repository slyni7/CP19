--QC Dracofear
function c81140060.initial_effect(c)

	c:EnableReviveLimit()

	--status increase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81140060.cn)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_RITUAL))
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(400)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c81140060.val)
	c:RegisterEffect(e3)
	
	--battle relate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c81140060.ecn)
	e4:SetTargetRange(0,1)
	e4:SetValue(c81140060.val2)
	c:RegisterEffect(e4)
	
	--salvage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81140060,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c81140060.vcn)
	e5:SetTarget(c81140060.vtg)
	e5:SetOperation(c81140060.vop)
	c:RegisterEffect(e5)
end

--status
function c81140060.cn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL) and c:GetFlagEffect(81140060)~=0
end

function c81140060.val(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0xcb1) then
		c:RegisterFlagEffect(81140060,RESET_EVENT+0x6e0000,0,1)
	end
end

--battle
function c81140060.ecn(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local tp=e:GetHandlerPlayer()
	return tc and tc:IsControler(tp) and tc:IsType(TYPE_RITUAL)
end
function c81140060.val2(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

--salvage
function c81140060.vcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c81140060.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb1)
end
function c81140060.vtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c81140060.filter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81140060.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81140060.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81140060.vop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
