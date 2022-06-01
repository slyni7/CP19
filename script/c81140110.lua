--QC Moder
function c81140110.initial_effect(c)

	c:EnableReviveLimit()
	
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81140110,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81140110)
	e1:SetCost(c81140110.co)
	e1:SetTarget(c81140110.tg)
	e1:SetOperation(c81140110.op)
	c:RegisterEffect(e1)
	
	--status increase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81140110.cn)
	e2:SetValue(c81140110.val)
	c:RegisterEffect(e2)
end

--search
function c81140110.co(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c81140110.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb1) and c:IsType(TYPE_MONSTER)
	and c:IsType(TYPE_RITUAL) and (not c:IsCode(81140110))
end
function c81140110.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_DECK+LOCATION_GRAVE
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81140110.filter,tp,loc,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function c81140110.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81140110.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--status
function c81140110.cn(e)
	local ph=Duel.GetCurrentPhase()
	if not (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) 
	or not e:GetHandler():IsRelateToBattle() then
		return false
	end
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsFaceup() and bc:GetSummonLocation()==LOCATION_EXTRA
end

function c81140110.val(e,c)
	return c:GetAttack()
end
