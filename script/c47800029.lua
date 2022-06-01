--약탈의 수행사적 안두인
function c47800029.initial_effect(c)

	c:SetSPSummonOnce(47800029)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c47800029.matfilter,1,1)

	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47800029,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,47800029)
	e2:SetCondition(c47800029.thcon)
	e2:SetTarget(c47800029.thtg)
	e2:SetOperation(c47800029.thop)
	c:RegisterEffect(e2)

	--gam sa hap ni da
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c47800029.regcon)
	e3:SetOperation(c47800029.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c47800029.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47800029,2))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCountLimit(1,47800030+EFFECT_COUNT_CODE_DUEL)
	e4:SetTarget(c47800029.cttg)
	e4:SetOperation(c47800029.ctop)
	c:RegisterEffect(e4)
end

function c47800029.matfilter(c)
	return c:IsLinkSetCard(0x49e) and c:IsAttribute(ATTRIBUTE_LIGHT)
end

function c47800029.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47800029.thfilter(c)
	return c:IsCode(47800008) and c:IsAbleToHand()
end
function c47800029.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47800029.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c47800029.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,nil,e:GetDescription())

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47800029.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
function c47800029.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c47800029.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c47800029.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(47800029,RESET_EVENT+RESETS_STANDARD,0,0)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(47800029,1))
end
function c47800029.valcheck(e,c)
	local g=c:GetMaterial()
	if g:GetClassCount(Card.GetLinkCode)==g:GetCount() and g:IsExists(Card.IsCode,1,nil,47800008) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end

function c47800029.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if chk==0 then
		local zone=bit.band(c:GetLinkedZone(),0x1f)
		return tc and tc:IsControlerCanBeChanged(false,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end

function c47800029.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetAttackTarget()
	if tc then
		local zone=bit.band(c:GetLinkedZone(),0x1f)
		Duel.GetControl(tc,tp,0,0,zone)

		Duel.Hint(HINT_OPSELECTED,nil,e:GetDescription())
	end
end