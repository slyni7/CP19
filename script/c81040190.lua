--The Ghost Keeper "REIUJI"

function c81040190.initial_effect(c)

	--summon method
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xca4),2,3)
	c:EnableReviveLimit()
	
	--enable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c81040190.filter)
	c:RegisterEffect(e1)
	
	--destroy and search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81040190,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81040190)
	e2:SetCondition(c81040190.dscn)
	e2:SetCost(c81040190.dsco)
	e2:SetTarget(c81040190.dstg)
	e2:SetOperation(c81040190.dsop)
	c:RegisterEffect(e2)
	
	--draw and damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81040190,1))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81040191)
	e3:SetCondition(c81040190.ddcn)
	e3:SetTarget(c81040190.ddtg)
	e3:SetOperation(c81040190.ddop)
	c:RegisterEffect(e3)
	
end

--enable
function c81040190.filter(e,te)
	return not te:GetOwner():IsSetCard(0xca4)
end

--destroy and search
function c81040190.dscnfilter(c,g)
	return c:IsFaceup() and g:IsContains(c)
end
function c81040190.dscn(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c81040190.dscnfilter,1,nil,lg)
end

function c81040190.dscofilter(c)
	return c:IsCode(81040000) and c:IsAbleToRemoveAsCost()
end
function c81040190.dsco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81040190.dscofilter,tp,LOCATION_GRAVE,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81040190.dscofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c81040190.dstgfilter(c)
	return c:IsSetCard(0xca4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c81040190.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c81040190.dstgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81040190.dsop(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81040190.dstgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--draw and damage
function c81040190.ddcn(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0xca4)
end
function c81040190.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,800)
end
function c81040190.ddop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Damage(tp,800,REASON_EFFECT)
	end
end
