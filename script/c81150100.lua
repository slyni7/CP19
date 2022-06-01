--Melodevil Notes-Calmato
function c81150100.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81150100,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81150100+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81150100.tg)
	e1:SetOperation(c81150100.op)
	c:RegisterEffect(e1)
end

--draw
function c81150100.filter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xcb2)
	and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c81150100.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c81150100.filter,tp,loc,0,1,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c81150100.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81150100.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end

	