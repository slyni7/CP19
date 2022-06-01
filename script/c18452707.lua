--카나디셈버　 사카미
function c18452707.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x12cf),aux.FilterBoolFunction(Card.IsFusionSetCard,0x2cf),true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetDescription(aux.Stringid(18452707,0))
	e1:SetCountLimit(1)
	e1:SetTarget(c18452707.tar1)
	e1:SetOperation(c18452707.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e2:SetDescription(aux.Stringid(18452707,1))
	e2:SetCountLimit(1)
	e2:SetCondition(c18452707.con2)
	e2:SetCost(c18452707.cost2)
	e2:SetTarget(c18452707.tar2)
	e2:SetOperation(c18452707.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c18452707.con3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,18452707)
	e4:SetDescription(aux.Stringid(18452707,2))
	e4:SetTarget(c18452707.tar4)
	e4:SetOperation(c18452707.op4)
	c:RegisterEffect(e4)
end
c18452707.material_setcode=0x2cf
c18452707.december_fmaterial=true
function c18452707.tfil1(c,e,tp)
	return (c:IsSetCard(0x2cf) or c:IsType(TYPE_FUSION)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(18452707)
end
function c18452707.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c18452707.tfil1(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c18452707.tfil1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c18452707.tfil1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c18452707.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then
		return
	end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	local atk=tc:GetAttack()
	if atk>0 then
		Duel.Recover(tp,math.ceil(atk/2),REASON_EFFECT)
	end
end
function c18452707.nfil2(c)
	return c:IsSetCard(0x2cf) and c:IsFaceup()
end
function c18452707.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not Duel.IsExistingMatchingCard(c18452707.nfil2,tp,LOCATION_ONFIELD,0,1,c)
end
function c18452707.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(18452707)<1
	end
	c:RegisterFlagEffect(18452707,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
end
function c18452707.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
			and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)
			and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE)
end
function c18452707.op2(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:RandomSelect(tp,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.HintSelection(sg1)
		local tc=sg1:GetFirst()
		local atk=0
		local tatk=0
		while tc do
			tatk=tc:GetAttack()
			if tatk>0 then
				atk=atk+tatk
			end
			tc=sg1:GetNext()
		end
		Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
		if atk>0 then
			Duel.Recover(tp,math.ceil(atk/2),REASON_EFFECT)
		end
	end
end
function c18452707.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c18452707.nfil2,tp,LOCATION_ONFIELD,0,1,c)
end
function c18452707.tfil4(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return te and (c:IsSetCard(0x2cf) or c:IsSetCard(0x46)) and (ft>0 or c:IsType(TYPE_FIELD)) and c:IsType(TYPE_SPELL) and te:IsActivatable(tp)
end
function c18452707.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18452707.tfil4,tp,LOCATION_DECK,0,1,nil,tp)
	end
end
function c18452707.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local tg=Duel.SelectMatchingCard(tp,c18452707.tfil4,tp,LOCATION_DECK,0,1,1,nil,tp)
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