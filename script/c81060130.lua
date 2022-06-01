--오렌지래빗

function c81060130.initial_effect(c)
	
	--draw, ended
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81060130+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81060130.shco)
	e1:SetTarget(c81060130.shtg)
	e1:SetOperation(c81060130.shop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c81060130.hand)
	c:RegisterEffect(e2)
	
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c81060130.dmcn)
	e3:SetCost(c81060130.dmco)
	e3:SetOperation(c81060130.dmop)
	c:RegisterEffect(e3)
	
end

function c81060130.hand(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)<1
end
	
--add to hand
function c81060130.shcofilter(c)
	return c:IsReleasable() and ( c:IsType(TYPE_MONSTER) and c:IsSetCard(0xca7) )
end
function c81060130.shco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_MZONE
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81060130.shcofilter,tp,loc,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81060130.shcofilter,tp,loc,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c81060130.shtgfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP) 
	   and (not c:IsCode(81060130) and c:IsSetCard(0xca7) )
	    or c:IsSetCard(0xca8)
end
function c81060130.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81060130.shtgfilter,tp,LOCATION_DECK,0,1,nil)
			end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81060130.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81060130.shtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--damage reduce
function c81060130.dmcnfilter(c)
	return c:IsSetCard(0xca7)
end
function c81060130.dmcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81060130.dmcnfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
end

function c81060130.dmco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c81060130.dmop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
