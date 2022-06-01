function c81130040.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,81130040)
	e1:SetTarget(c81130040.tg)
	e1:SetOperation(c81130040.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(1,81130041)
	e3:SetCondition(c81130040.ecn)
	e3:SetCost(c81130040.eco)
	e3:SetTarget(c81130040.etg)
	e3:SetOperation(c81130040.eop)
	c:RegisterEffect(e3)
end

--special summon
function c81130040.filter(c,e,tp)
	return c:IsSetCard(0xcb0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81130040.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81130040.filter(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81130040.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81130040.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81130040.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local fid=tc:GetFieldID()
		tc:RegisterFlagEffect(81130040,RESET_EVENT+0x1fe0000,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c81130040.vcn)
		e1:SetOperation(c81130040.vop)
		Duel.RegisterEffect(e1,tp)
		Duel.SpecialSummonComplete()
	end
end
function c81130040.vcn(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(81130040)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c81130040.vop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end

--summoned
function c81130040.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:GetPreviousLocation(LOCATION_ONFIELD)
	and c:IsSetCard(0xcb0) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
	and c:IsPreviousPosition(POS_FACEUP) and bit.band(c:GetReason(),0x41)==0x41
end
function c81130040.ecn(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81130040.cfilter,1,e:GetHandler(),tp)
end
function c81130040.eco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsAbleToRemoveAsCost()
	end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c81130040.sfilter(c)
	return c:IsSetCard(0xcb0) and c:IsSummonable(true,nil)
end
function c81130040.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81130040.sfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c81130040.eop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c81130040.sfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
