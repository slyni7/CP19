--얼터네이트 스틱킹

function c81070110.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c81070110.atcn)
	c:RegisterEffect(e0)
	
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,81070110)
	e2:SetCost(c81070110.idco)
	e2:SetTarget(c81070110.idtg)
	e2:SetOperation(c81070110.idop)
	c:RegisterEffect(e2)
	
	--atk increase
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c81070110.aicn)
	e3:SetTarget(c81070110.aitg)
	e3:SetOperation(c81070110.aiop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c81070110.aicn2)
	c:RegisterEffect(e4)
	
end
--activate
function c81070110.atcnfilter(c)
	return c:IsFaceup() 
	   and ( c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
end
function c81070110.atcn(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c81070110.atcnfilter,tp,LOCATION_ONFIELD,0,nil)==0
end
--indes
function c81070110.idcofilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcaa)
	   and c:IsAbleToGraveAsCost()
end
function c81070110.idco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_DECK
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81070110.idcofilter,tp,loc,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81070110.idcofilter,tp,loc,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c81070110.idtgfilter(c)
	return c:IsFaceup() and c:IsCode(81070000)
end
function c81070110.idtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsLocation(LOCATION_MZONE)
			and chkc:IsControler(tp)
			and c81070110.idtgfilter(chkc)
			end
	if chk==0 then return
				Duel.IsExistingTarget(c81070110.idtgfilter,tp,LOCATION_MZONE,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81070110.idtgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c81070110.idop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e4:SetValue(c81070110.idvl)
		tc:RegisterEffect(e4)
	end
end
function c81070110.idvl(e,re,tp)
	return tp~=e:GetOwnerPlayer()
end

--atk increase
function c81070110.aicn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0)
	   and re:GetHandler():IsSetCard(0xcaa)
end
function c81070110.aicn2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end

function c81070110.aitgfilter(c)
	return c:IsFaceup() and ( c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcaa) )
end
function c81070110.aitg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsLocation(LOCATION_MZONE)
			and chkc:IsControler(tp)
			and c81070110.aitgfilter(chkc)
			end
	if chk==0 then return
				Duel.IsExistingTarget(c81070110.aitgfilter,tp,LOCATION_MZONE,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81070110.aitgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c81070110.aiop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
