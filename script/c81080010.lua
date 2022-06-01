--開宴

function c81080010.initial_effect(c)

	--Act
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81080010+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81080010.atco)
	e1:SetTarget(c81080010.attg)
	e1:SetOperation(c81080010.atop)
	c:RegisterEffect(e1)
	
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c81080010.rltg)
	e2:SetValue(c81080010.rlvl)
	e2:SetOperation(c81080010.rlop)
	c:RegisterEffect(e2)

end

--Act
function c81080010.atco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1000)
	end
	Duel.PayLPCost(tp,1000)
end
function c81080010.attgfilter(c,e,tp)
	return c:IsSetCard(0xcab) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81080010.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81080010.attgfilter(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c81080010.attgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81080010.attgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81080010.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--replace
function c81080010.rltgfilter(c,tp)
	return c:IsFaceup() and c:IsOnField() and c:IsControler(tp)
	   and c:IsSetCard(0xcab)
	   and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c81080010.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				c:IsAbleToRemove()
		   and eg:IsExists(c81080010.rltgfilter,1,nil,tp)
		   end
	return Duel.SelectYesNo(tp,aux.Stringid(81080010,0))
end

function c81080010.rlvl(e,c)
	return c81080010.rltgfilter(c,e:GetHandlerPlayer())
end

function c81080010.rlop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end



