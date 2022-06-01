--디셈버　 메구미
function c18452701.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(18452701,0))
	e1:SetCost(c18452701.cost1)
	e1:SetTarget(c18452701.tar1)
	e1:SetOperation(c18452701.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MULTIPLE_FUSION_MATERIAL)
	e2:SetValue(c18452701.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetTarget(c18452701.tar3)
	e3:SetOperation(c18452701.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e4:SetDescription(aux.Stringid(18452701,1))
	e4:SetTarget(c18452701.tar4)
	e4:SetOperation(c18452701.op4)
	c:RegisterEffect(e4)
end
function c18452701.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c18452701.tfil1(c)
	return c:IsCode(18452711) and c:IsAbleToHand()
end
function c18452701.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18452701.tfil1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18452701.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18452701.tfil1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c18452701.val2(e,c)
	if c:IsSetCard(0x2cf) then
		return 2
	end
	return 1
end
function c18452701.tfil3(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return te and c:IsSetCard(0x2cf) and (ft>0 or c:IsType(TYPE_FIELD)) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY) and te:IsActivatable(tp)
end
function c18452701.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18452701.tfil3,tp,LOCATION_DECK,0,1,nil,tp)
	end
end
function c18452701.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local tg=Duel.SelectMatchingCard(tp,c18452701.tfil3,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=tg:GetFirst()
	if tc then
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local co=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		if bit.band(tpe,TYPE_FIELD)>0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		Duel.HintActivation(te)
		e:SetActiveEffect(te)
		te:UseCountLimit(tp,1,true)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)<1 then
			tc:CancelToGrave(false)
		end
		tc:CreateEffectRelation(te)
		if co then
			co(te,tp,eg,ep,ev,re,r,rp,1)
		end
		if tg then
			tg(te,tp,eg,ep,ev,re,r,rp,1)
		end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local etc=nil
		if g then
			etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op and not tc:IsDisabled() then
			op(te,tp,eg,ep,ev,re,r,rp)
		end
		tc:ReleaseEffectRelation(te)
		if g then
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
		e:SetActiveEffect(nil)
		e:SetCategory(0)
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
		Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c18452701.tfil4(c,e,tp,g)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(g,nil,tp)
end
function c18452701.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18452701.tfil4,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(c))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c18452701.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsImmuneToEffect(e) or not c:IsRelateToEffect(e) then
		return
	end
	local mg=Group.FromCards(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18452701.tfil4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,tp)
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end