--엔디셈버　 에리스
function c18452702.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2cf),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE+ATTRIBUTE_WIND+ATTRIBUTE_WATER),true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTarget(c18452702.tar1)
	e1:SetOperation(c18452702.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetDescription(aux.Stringid(18452702,0))
	e2:SetCountLimit(1)
	e2:SetCondition(c18452702.con2)
	e2:SetCost(c18452702.cost2)
	e2:SetTarget(c18452702.tar2)
	e2:SetOperation(c18452702.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON)
	e3:SetCondition(c18452702.con3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,18452702)
	e4:SetDescription(aux.Stringid(18452702,1))
	e4:SetTarget(c18452702.tar4)
	e4:SetOperation(c18452702.op4)
	c:RegisterEffect(e4)
end
c18452702.material_setcode=0x2cf
c18452702.december_fmaterial=true
function c18452702.tfil1(c,bc)
	local be={c:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
	for _,te in pairs(be) do
		local v=te:GetValue()
		if not v or v==1 or v(te,bc) then
			return false
		end
	end
	return not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c18452702.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
	end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a and a~=c and c18452702.tfil1(a,c) then
		e:SetLabelObject(a)
		a:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	if d and a~=d and c18452702.tfil1(d,c) then
		e:SetLabelObject(d)
		d:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function c18452702.desrepval(e,c)
	return c==e:GetHandler()
end
function c18452702.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,18452702)
	local bc=e:GetLabelObject()
	bc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(bc,REASON_BATTLE+REASON_REPLACE)
end
function c18452702.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()<1 and ep~=tp
end
function c18452702.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(18452702)<1
	end
	c:RegisterFlagEffect(18452702,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
end
function c18452702.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c18452702.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local atk=0
	local tatk=0
	while tc do
		tatk=tc:GetAttack()
		if tatk>0 then
			atk=atk+tatk
		end
		tc=eg:GetNext()
	end
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	if atk>0 then
		Duel.Recover(tp,math.ceil(atk/2),REASON_EFFECT)
	end
end
function c18452702.nfil3(c)
	return c:IsSetCard(0x2cf) and c:IsFaceup()
end
function c18452702.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetCurrentChain()<1 and ep~=tp and Duel.IsExistingMatchingCard(c18452703.nfil3,tp,LOCATION_ONFIELD,0,1,c)
end
function c18452702.tfil4(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return te and c:IsSetCard(0x2cf) and (ft>0 or c:IsType(TYPE_FIELD)) and c:IsType(TYPE_SPELL) and te:IsActivatable(tp)
end
function c18452702.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18452702.tfil4,tp,LOCATION_DECK,0,1,nil,tp)
	end
end
function c18452702.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local tg=Duel.SelectMatchingCard(tp,c18452702.tfil4,tp,LOCATION_DECK,0,1,1,nil,tp)
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