--장기
--카드군 번호: 0xca6
function c81050090.initial_effect(c)

	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81050090+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81050090.co1)
	e1:SetTarget(c81050090.tg1)
	e1:SetOperation(c81050090.op1)
	c:RegisterEffect(e1)
	
	--search & to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81050090,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(0x10)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81050090.thtg)
	e2:SetOperation(c81050090.thop)
	c:RegisterEffect(e2)
	
end

--destroy
function c81050090.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xca6)
end
function c81050090.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81050090.cfil0,tp,0x10,0,1,nil)
	end
	local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,0x0c,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81050090.cfil0,tp,0x10,0,1,ct,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(#g)
end
function c81050090.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0x0c)
end
function c81050090.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,0x0c,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,ct,nil)
	Duel.HintSelection(sg)
	Duel.Destroy(sg,REASON_EFFECT)
end

--search & to hand
function c81050090.thco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function c81050090.thtgfilter(c)
	return c:IsLevelAbove(5) and ( c:IsSetCard(0xca6) and c:IsType(TYPE_MONSTER) )
	and c:IsAbleToHand()
end
function c81050090.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
				Duel.IsExistingMatchingCard(c81050090.thtgfilter,tp,LOCATION_DECK,0,1,nil)
			end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81050090.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81050090.thtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
