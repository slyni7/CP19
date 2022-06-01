--QC Riverside
function c81140030.initial_effect(c)

	c:EnableReviveLimit()
	--attack limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c81140030.cn)
	e1:SetTarget(c81140030.tg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c81140030.eop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,81140030)
	e3:SetCost(c81140030.hco)
	e3:SetTarget(c81140030.htg)
	e3:SetOperation(c81140030.hop)
	c:RegisterEffect(e3)
end

--limited
function c81140030.cn(e)
	return e:GetHandler():GetFlagEffect(81140030)~=0 and e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c81140030.tg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c81140030.eop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(81140030)~=0 then
		return
	end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterEffect(81140030,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end

--serach
function c81140030.hco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c81140030.filter(c)
	return c:IsAbleToHand() and c:IsCode(81140080)
end
function c81140030.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81140030.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c81140030.hop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81140030.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
