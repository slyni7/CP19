--USS 라피
function c81170050.initial_effect(c)

	--atk inc.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(c81170050.cn)
	e1:SetOperation(c81170050.op)
	c:RegisterEffect(e1)
	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81170050,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,81170050)
	e2:SetCondition(c81170050.vcn)
	e2:SetTarget(c81170050.vtg)
	e2:SetOperation(c81170050.vop)
	c:RegisterEffect(e2)
end

--atk inc.
function c81170050.filter1(c,tp,atk)
	return c:IsFaceup() and c:IsControler(1-tp) and c:GetAttack()>atk
end
function c81170050.cn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() 
	and bc:GetAttack()>atk
end
function c81170050.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1200)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end

--search
function c81170050.vcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c81170050.filter2(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb4) and c:IsType(TYPE_MONSTER)
	and not c:IsSummonableCard()
end
function c81170050.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_DECK+LOCATION_GRAVE
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81170050.filter2,tp,loc,0,1,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function c81170050.vop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81170050.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


