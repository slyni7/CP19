--HMS(로열 네이비) 셰필드
--카드군 번호: 0xcb7
function c81200150.initial_effect(c)

	--소재제약
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetValue(c81200150.lm1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e2)
	
	--특수소환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81200150,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(1,81200150)
	e3:SetCost(c81200150.co3)
	e3:SetTarget(c81200150.tg3)
	e3:SetOperation(c81200150.op3)
	c:RegisterEffect(e3)
end

--소재제약
function c81200150.lm1(e,c)
	if not c then
		return false
	end
	return not c:IsSetCard(0xcb7)
end

--특수소환
function c81200150.cfilter0(c,ft)
	return c:IsAbleToHandAsCost() and c:IsFaceup() and c:IsSetCard(0xcb7)
	and ( ft>0 or c:GetSequence()<5 )
end
function c81200150.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		return ft>-1 
		and Duel.IsExistingMatchingCard(c81200150.cfilter0,tp,LOCATION_MZONE,0,1,nil,ft)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c81200150.cfilter0,tp,LOCATION_MZONE,0,1,1,nil,ft)
	if g:GetFirst():IsSetCard(0xcb8) then 
		e:SetLabel(1) 
	else 
		e:SetLabel(0)
	end
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c81200150.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	if e:GetLabel(1) then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c81200150.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
		if e:GetLabel()==1 and Duel.SelectYesNo(tp,aux.Stringid(81200150,1)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end


