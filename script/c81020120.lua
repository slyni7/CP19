--방문객

function c81020120.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	
	--des.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(0x04)
	e1:SetCountLimit(1,81020121)
	e1:SetCost(c81020120.deco)
	e1:SetTarget(c81020120.detg)
	e1:SetOperation(c81020120.deop)
	c:RegisterEffect(e1)
	
	--hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81020120,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,81020120)
	e2:SetCondition(c81020120.thcn)
	e2:SetCost(c81020120.thco)
	e2:SetTarget(c81020120.thtg)
	e2:SetOperation(c81020120.thop)
	c:RegisterEffect(e2)
	
end

--des.
function c81020120.decofilter(c)
	return c:IsSetCard(0xca2) and c:IsDiscardable()
end
function c81020120.deco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c81020120.decofilter,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,c81020120.decofilter,1,1,REASON_COST+REASON_DISCARD)
end

function c81020120.detg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
		chkc:IsOnField() and c:IsDestructable()
	end
	if chk==0 then return
		Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_SZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_SZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function c81020120.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end

--hand
function c81020120.thcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end

function c81020120.tfil0(c)
	return c:IsSetCard(0xca2) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c81020120.thco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c81020120.tfil0,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81020120.tfil0,tp,LOCATION_DECK,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SendtoGrave(g,REASON_COST)
end

function c81020120.tfil1(c,rc)
	return c:IsSetCard(0xca2) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
	and not c:IsCode(rc)
end
function c81020120.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c81020120.tfil1,tp,LOCATION_DECK,0,1,nil,e:GetLabel())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81020120.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81020120.tfil1,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
