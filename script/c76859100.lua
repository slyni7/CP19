--Angel Notes - Å¬¶óÀÌ¸Æ½º
function c76859100.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCountLimit(1,76859100+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c76859100.op1)
	c:RegisterEffect(e1)
end
function c76859100.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetOperation(c76859100.op11)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e1)
	e2:SetOperation(c76859100.op12)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c76859100.op11(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x2c8) and tc:IsControler(tp) and not tc:IsCode(76859100) then
			e:SetLabel(e:GetLabel()+1)
		end
		tc=eg:GetNext()
	end
end
function c76859100.ofilter12(c)
	return c:IsSetCard(0x2c8) and c:IsSSetable() and not c:IsType(TYPE_FIELD) and not c:IsCode(76859100)
end
function c76859100.op12(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	if ct>0 then
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c76859100.ofilter12,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.SSet(tp,tc)
		end
	end
end