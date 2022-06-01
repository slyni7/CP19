--Melodevil Ramentando
function c81150050.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c81150050.mat),2,4,c81150050.mat2)
	
	--status increase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c81150050.val)
	c:RegisterEffect(e1)
	
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81150050,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,81150050)
	e2:SetCondition(c81150050.vcn)
	e2:SetTarget(c81150050.vtg)
	e2:SetOperation(c81150050.vop)
	c:RegisterEffect(e2)
	
	--무효
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c81150050.Mzcn)
	e3:SetOperation(c81150050.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCondition(c81150050.Szcn)
	c:RegisterEffect(e4)
end

--material
function c81150050.mat(c,lc,sumtype,tp)
	return c:IsType(TYPE_EFFECT,lc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_WIND,lc,sumtype,tp)
end
function c81150050.mat2(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xcb2)
end

--status
function c81150050.valfilter(c)
	return c:IsSetCard(0xcb2) and c:IsFaceup()
end
function c81150050.val(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c81150050.valfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)*100
end

--salvage
function c81150050.vcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c81150050.filter2(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb2) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81150050.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81150050.filter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c81150050.vop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81150050.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--무효
function c81150050.Mzfil(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and c:IsSetCard(0xcb2) and c:IsType(TYPE_LINK) and seq1==4-seq2
end
function c81150050.Mzcn(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	seq=aux.MZoneSequence(seq)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
	and Duel.IsExistingMatchingCard(c81150050.Mzfil,tp,LOCATION_MZONE,0,1,nil,seq)
end
function c81150050.Szcn(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return rp==1-tp and ( re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP) )
	and loc&LOCATION_SZONE==LOCATION_SZONE and seq<=4
	and Duel.IsExistingMatchingCard(c81150050.Mzfil,tp,LOCATION_MZONE,0,1,nil,seq)
end
function c81150050.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,81150050)
	Duel.NegateEffect(ev)
end
