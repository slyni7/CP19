--네파시아 엑스큐션
function c47550018.initial_effect(c)
	--destroy one card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47500018,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,47550018)
	e1:SetTarget(c47550018.destg)
	e1:SetOperation(c47550018.desop)
	c:RegisterEffect(e1)
end


function c47550018.costfilter(c)
	return c:IsSetCard(0x487)
end

function c47550018.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x487) and c:IsType(TYPE_LINK) and c:GetLinkedGroupCount()>0
end


function c47550018.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end

	local b1=Duel.IsExistingMatchingCard(c47550018.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e:GetHandler(),tp)

	local b2=Duel.IsExistingTarget(c47550018.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)

	if chk==0 then return b1 or b2 end

	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(47550018,0),aux.Stringid(47550018,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(47550018,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(47550018,1))+1
	end
	e:SetLabel(op)

	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c47550018.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e:GetHandler(),tp)
		Duel.SendtoGrave(g,REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c47550018.filter,tp,LOCATION_MZONE,0,1,1,nil)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end

end



function c47550018.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	else
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,tc:GetLinkedGroupCount(),nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end