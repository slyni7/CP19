--하이사이버네틱 네리하
local m=99000393
local cm=_G["c"..m]
function cm.initial_effect(c)
	--order summon
	aux.AddOrderProcedure(c,"L",cm.orderchk,aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),cm.ordfil1)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(cm.imcon)
	e1:SetOperation(cm.imop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(aux.bdogcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
cm.CardType_Order=true
function cm.orderchk(g)
	return g:GetClassCount(Card.GetLinkAttribute)==2
end
function cm.ordfil1(c)
	return c:GetAttackAnnouncedCount()==0 and c:IsType(TYPE_MONSTER)
end
function cm.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ORDER)
end
function cm.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(cm.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActivated()
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	local atk=bc:GetTextAttack()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and bc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
	local b2=atk>0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3),aux.Stringid(m,4))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))+1
	end
	if op==0 then
		Duel.SetTargetCard(bc)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,0)
	elseif op==1 then
		Duel.SetTargetCard(bc)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(atk)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
	elseif op==2 then
		Duel.SetTargetCard(bc)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(atk)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	end
	e:SetLabel(op)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	elseif e:GetLabel()==1 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
			local atk=tc:GetTextAttack()
			if atk<0 then atk=0 end
			Duel.Recover(p,atk,REASON_EFFECT)
		end
	elseif e:GetLabel()==2 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
			local atk=tc:GetTextAttack()
			if atk<0 then atk=0 end
			Duel.Damage(p,atk,REASON_EFFECT)
		end
	end
end