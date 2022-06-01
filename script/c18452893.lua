--테야하-희도섬
function c18452893.initial_effect(c)
	c:SetSPSummonOnce(18452893)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c18452893.matfilter,1,1)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18452893,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetTarget(c18452893.tgtg)
	e2:SetOperation(c18452893.tgop)
	c:RegisterEffect(e2)
end
function c18452893.matfilter(c)
	return c:IsLinkSetCard(0x12da) and not c:IsLinkAttribute(ATTRIBUTE_WIND)
end
function c18452893.tgfilter(c)
	return c:IsSetCard(0x2da) and c:IsAbleToGrave()
end
function c18452893.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18452893.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c18452893.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18452893.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
