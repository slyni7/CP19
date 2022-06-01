--엔디셈버　 아오바
function c18452703.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2cf),2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCountLimit(1)
	e1:SetCondition(c18452703.con1)
	e1:SetOperation(c18452703.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetDescription(aux.Stringid(18452703,0))
	e2:SetCountLimit(1)
	e2:SetCondition(c18452703.con2)
	e2:SetTarget(c18452703.tar2)
	e2:SetOperation(c18452703.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,18452703)
	e3:SetDescription(aux.Stringid(18452703,1))
	e3:SetTarget(c18452703.tar3)
	e3:SetOperation(c18452703.op3)
	c:RegisterEffect(e3)
end
c18452703.material_setcode=0x2cf
c18452703.december_fmaterial=true
function c18452703.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc
end
function c18452703.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToBattle() and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL+RESET_EVENT+0x1ff0000)
		e1:SetValue(c:GetBaseAttack())
		c:RegisterEffect(e1)
	end
end
function c18452703.nfil2(c)
	return c:IsSetCard(0x2cf) and c:IsFaceup()
end
function c18452703.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then
		return false
	end
	return re:IsActiveType(TYPE_MONSTER) or (re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(c18452703.nfil2,tp,LOCATION_ONFIELD,0,1,c))
end
function c18452703.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c18452703.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local atk=rc:GetAttack()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	if atk>0 then
		Duel.Recover(tp,math.ceil(atk/2),REASON_EFFECT)
	end
end
function c18452703.tfil3(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return te and c:IsSetCard(0x2cf) and (ft>0 or c:IsType(TYPE_FIELD)) and c:IsType(TYPE_SPELL) and te:IsActivatable(tp)
end
function c18452703.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18452703.tfil3,tp,LOCATION_DECK,0,1,nil,tp)
	end
end
function c18452703.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local tg=Duel.SelectMatchingCard(tp,c18452703.tfil3,tp,LOCATION_DECK,0,1,1,nil,tp)
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