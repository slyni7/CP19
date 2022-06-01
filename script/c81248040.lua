--THE CELL - 브레이크다운
function c81248040.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(81248040,0))
	e1:SetCountLimit(1,81248040)
	e1:SetValue(c81248040.val1)
	e1:SetTarget(c81248040.tar1)
	e1:SetOperation(c81248040.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(81248040,1))
	e2:SetCountLimit(1,81248041)
	e2:SetCondition(c81248040.con2)
	e2:SetTarget(c81248040.tar2)
	e2:SetOperation(c81248040.op2)
	c:RegisterEffect(e2)
end
function c81248040.vfil1(c,e)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c81248040.val1(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local g=Duel.GetMatchingGroup(c81248040.vfil1,tp,LOCATION_ONFIELD,0,nil,e)
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local tc0=Duel.GetFieldCard(tp,LOCATION_SZONE,0)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,4)
	if p0==p1 then
		return zone
	end
	if not p0 and not g:IsContains(tc0) then
		zone=zone-0x10
	end
	if not p1 and not g:IsContains(tc1) then
		zone=zone-0x1
	end
	return zone
end
function c81248040.tfil11(c,tp)
	if c:IsFaceup() and c:IsAbleToHand() then
		local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
		local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
		if p0 or p1 then
			return true
		else
			local seq=c:GetSequence()
			return c:IsLocation(LOCATION_SZONE) and (seq==0 or seq==4)
		end
	end
	return false
end
function c81248040.tfil12(c)
	return c:IsSetCard(0xc84) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c81248040.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsOnField() and c81248040.tfil11(chkc,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81248040.tfil11,tp,LOCATION_ONFIELD,0,1,nil,tp)
			and Duel.IsExistingMatchingCard(c81248040.tfil12,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81248040.tfil11,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81248040.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g=Duel.SelectMatchingCard(tp,c81248040.tfil12,tp,LOCATION_DECK,0,1,1,nil)
			local pc=g:GetFirst()
			if pc then
				Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	end
end
function c81248040.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()&(PHASE_MAIN1+PHASE_MAIN2)>0
end
function c81248040.tfil21(c,e,tp)
	return c:IsSetCard(0xc84) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c81248040.tfil22(c,e)
	return c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsReleasableByEffect(e)
end
function c81248040.tfil23(c,tp,sg)
	return sg:CheckSubGroup(c81248040.tfun2,1,#sg,tp,c)
end
function c81248040.tfun2(g,tp,c)
	return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),#g,#g)
end
function c81248040.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c81248040.tfil21,tp,LOCATION_EXTRA,0,nil,e,tp)
	local sg=Duel.GetMatchingGroup(c81248040.tfil22,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_EXTRA,0,nil,e)
	if chk==0 then
		return c:IsAbleToDeck() and g:IsExists(c81248040.tfil23,1,nil,tp,sg)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c81248040.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c81248040.tfil21,tp,LOCATION_EXTRA,0,nil,e,tp)
	local sg=Duel.GetMatchingGroup(c81248040.tfil22,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_EXTRA,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:FilterSelect(tp,c81248040.tfil23,1,1,nil,tp,sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=sg:SelectSubGroup(tp,c81248040.tfun2,false,1,#sg,tp,tc)
	if Duel.SendtoGrave(rg,REASON_EFFECT+REASON_RELEASE)>0 and Duel.GetLocationCountFromEx(tp,tp,nil,tc) then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
	if c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end