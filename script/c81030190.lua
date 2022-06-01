function c81030190.initial_effect(c)

	--summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),2,2,c81030190.mat)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c81030190.tg)
	e1:SetValue(c81030190.val)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81030190)
	e2:SetCost(c81030190.co2)
	e2:SetTarget(c81030190.tg2)
	e2:SetOperation(c81030190.op2)
	c:RegisterEffect(e2)
end

--mat
function c81030190.mat(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xca3)
end

--replace
function c81030190.tgfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_SZONE)
	and c:IsSetCard(0xca3) and c:IsReason(REASON_EFFECT) and c:GetFlagEffect(81030190)==0
end
function c81030190.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return eg:IsExists(c81030190.tgfilter,1,nil,tp)
	end
	local g=eg:Filter(c81030190.tgfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(81030190,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(81030190,0))
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end

function c81030190.val(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end

--place
function c81030190.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=LOCATION_ONFIELD
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then ft=LOCATION_SZONE end
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,ft,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,ft,0,1,1,c)
	Duel.Destroy(g,REASON_COST)
end
function c81030190.tfil(c)
	return not c:IsForbidden() and c:IsSetCard(0xca3) and c:IsType(TYPE_MONSTER)
end
function c81030190.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81030190.tfil,tp,0x02+0x10,0,1,nil)
	end
end
function c81030190.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c81030190.tfil,tp,0x02+0x10,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
