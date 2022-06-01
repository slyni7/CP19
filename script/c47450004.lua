--폭린룡 바젤기우스
function c47450004.initial_effect(c)
		--public 
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetRange(LOCATION_HAND)
		e0:SetCode(EFFECT_PUBLIC)
		c:RegisterEffect(e0)

		--battle
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(47450004,0))
		e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetRange(LOCATION_HAND)
		e1:SetCountLimit(1,47450004)
		e1:SetCost(c47450004.batcos)
		e1:SetOperation(c47450004.ssop)
		c:RegisterEffect(e1)

		--effect
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(47450004,1))
		e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_QUICK_F)
		e2:SetCode(EVENT_CHAINING)
		e2:SetRange(LOCATION_HAND)
		e2:SetCountLimit(1,47450004)
		e2:SetCost(c47450004.efcos)
		e2:SetOperation(c47450004.ssop)
		c:RegisterEffect(e2)

		--destroy & bounce
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(47450004,2))
		e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetCost(c47450004.desco)
		e3:SetOperation(c47450004.desop)
		c:RegisterEffect(e3)
end


function c47450004.batcos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=Duel.GetAttacker()
	local tc2=Duel.GetAttackTarget()

	if tc and tc2 then
	Duel.Destroy(tc,REASON_COST)
	Duel.Destroy(tc2,REASON_COST)
	end
end

function c47450004.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end



function c47450004.efcos(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc and rc:IsType(TYPE_MONSTER) end
	if rc:IsType(TYPE_MONSTER) and rc:IsRelateToEffect(re) and rc:IsDestructable() then
	Duel.Destroy(rc,REASON_COST)
end
end



function c47450004.descofilter(c,e)
	return c:IsDestructable()
end
function c47450004.desco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c47450004.descofilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	end
	local g=Duel.SelectMatchingCard(tp,c47450004.descofilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.Destroy(g,REASON_COST)
end

function c47450004.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end