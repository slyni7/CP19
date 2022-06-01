--엔디셈버　 에리나
function c18452705.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2cf),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT+ATTRIBUTE_EARTH+ATTRIBUTE_DARK),true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,18452705)
	e1:SetTarget(c18452705.tar1)
	e1:SetOperation(c18452705.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetDescription(aux.Stringid(18452705,0))
	e2:SetCountLimit(1)
	e2:SetTarget(c18452705.tar2)
	e2:SetOperation(c18452705.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,18452706)
	e3:SetDescription(aux.Stringid(18452705,1))
	e3:SetTarget(c18452705.tar3)
	e3:SetOperation(c18452705.op3)
	c:RegisterEffect(e3)
end
c18452705.material_setcode=0x2cf
c18452705.december_fmaterial=true
function c18452705.tfil1(c)
	return (c:IsSetCard(0x2cf) or c:IsSetCard(0x46)) and c:IsAbleToHand()
end
function c18452705.tfun1(c)
	local val=0
	if c:IsSetCard(0x2cf) and c:IsSetCard(0x46) then
		val=0x10002
	elseif c:IsSetCard(0x2cf) then
		val=0x10001
	else
		val=0x20002
	end
	if c:IsLocation(LOCATION_GRAVE) then
		val=val+0x100010
	else
		val=val+0x200020
	end
	return val
end
function c18452705.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c18452705.tfil1,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if chk==0 then
		return g:CheckWithSumEqual(c18452705.tfun1,0x33,2,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c18452705.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c18452705.tfil1,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectWithSumEqual(tp,c18452705.tfun1,0x33,2,2)
	if sg:GetCount()>1 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c18452705.tfil21(c,tp,tc)
	return c:IsFaceup() and not c:IsDisabled() 
		and (c:IsType(TYPE_MONSTER)
			or (c:IsType(TYPE_SPELL+TYPE_TRAP)
				and Duel.IsExistingMatchingCard(c18452705.tfil22,tp,LOCATION_ONFIELD,0,1,tc)))
end
function c18452705.tfil22(c)
	return c:IsSetCard(0x2cf) and c:IsFaceup()
end
function c18452705.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp) and c18452705.tfil21(chkc,tp,c)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c18452705.tfil21,tp,0,LOCATION_ONFIELD,1,nil,tp,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c18452705.tfil21,tp,0,LOCATION_ONFIELD,1,1,nil,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c18452705.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		return
	end
	if not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
	local atk=tc:GetAttack()
	if atk>0 then
		Duel.Recover(tp,math.ceil(atk/2),REASON_EFFECT)
	end
end
function c18452705.tfil3(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return te and c:IsSetCard(0x46) and (ft>0 or c:IsType(TYPE_FIELD)) and c:IsType(TYPE_SPELL) and te:IsActivatable(tp)
end
function c18452705.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18452705.tfil3,tp,LOCATION_DECK,0,1,nil,tp)
	end
end
function c18452705.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local tg=Duel.SelectMatchingCard(tp,c18452705.tfil3,tp,LOCATION_DECK,0,1,1,nil,tp)
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
		e:SetProperty(0)
		Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
	end
end