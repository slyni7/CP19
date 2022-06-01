--지상의 거미

function c81050140.initial_effect(c)

	--treat "yamame"
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(81050000)
	c:RegisterEffect(e2)
	
	--send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81050140,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81050140)
	e3:SetCost(c81050140.sgco)
	e3:SetTarget(c81050140.sgtg)
	e3:SetOperation(c81050140.sgop)
	c:RegisterEffect(e3)
	
end

--send to grave
function c81050140.sgco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end

function c81050140.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end

function c81050140.sgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local td=Duel.TossDice(tp,1)
	Duel.ConfirmDecktop(tp,td)
	local g=Duel.GetDecktopGroup(tp,td)
	local sg=g:Filter(Card.IsSetCard,nil,0xca6)
	if sg:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
		Duel.ShuffleDeck(tp)
	end
end

