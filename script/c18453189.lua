--Arom@ge - Berg@mot
local m=18453189
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")	
	e2:SetCode(EFFECT_CHANGE_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(1,0)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"S")
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(cm.con4)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"F","M")
	e5:SetCode(EFFECT_REVERSE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTR(1,0)
	e5:SetValue(cm.val5)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"F","M")
	e6:SetCode(EFFECT_EXTRA_ATTACK)
	e6:SetTR("M",0)
	e6:SetCondition(cm.con6)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2e6))
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"F","M")
	e7:SetCode(EFFECT_BP_TWICE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTR(1,0)
	e7:SetCondition(cm.con6)
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"FC","M")
	e8:SetCode(EVENT_RECOVER)
	WriteEff(e8,8,"O")
	c:RegisterEffect(e8)
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_FIRE,ATTRIBUTE_FIRE,ATTRIBUTE_FIRE,ATTRIBUTE_FIRE,ATTRIBUTE_FIRE}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil1(c)
	local te=c:CheckActivateEffect(false,false,false)
	return (te or c:IsAbleToHand()) and c:IsCode(18453200)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local tg=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	local tc=tg:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:CheckActivateEffect(false,false,false)
			or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			local tpe=tc:GetType()
			local te=tc:GetActivateEffect()
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			Duel.MoveToField(tc,tp,tp,LSTN("F"),POS_FACEUP,true)
			Duel.HintActivation(te)
			e:SetActiveEffect(te)
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
			if op then
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
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			e:SetProperty(0)
			Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function cm.val2(e,re,rec,r,rp)
	local tp=e:GetHandlerPlayer()
	if not GlobalAromaRecover[tp] then
		GlobalAromaRecover[tp]=true
		return rec*10
	end
	return rec
end
function cm.val3(e,re)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return c~=rc and (re:IsHasCategory(CATEGORY_RECOVER) or (re:IsActiveType(TYPE_MONSTER) and c:GetAttribute()&rc:GetAttribute()>0))
end
function cm.con4(e)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	return c==a
end
function cm.val5(e,re,r,rp,rc)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	return c==a and r&REASON_BATTLE>0
end
function cm.con6(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(1-tp)>0 and math.floor(Duel.GetLP(tp)/Duel.GetLP(1-tp))>=2
end
function cm.ofil81(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	return ((te and Duel.GetLocCount(tp,"S")>0) or c:IsAbleToHand()) and c:IsSetCard("Æ÷¼Ç") and c:GetType()==TYPE_SPELL
end
function cm.op8(e,tp,eg,ep,ev,re,r,rp)
	if not e then
		return
	end
	local c=e:GetHandler()
	local b1=true
	local b2=true
	for _,flag in ipairs({c:GetFlagEffectLabel(m)}) do
		if flag==1 then
			b1=false
		end
		if flag==2 then
			b2=false
		end
	end
	local g1=Duel.GMGroup(cm.ofil81,tp,"D",0,nil,tp)
	if b1 and #g1>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local tg=g1:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:CheckActivateEffect(false,false,false) or Duel.GetLocCount(tp,"S")<1
				or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				local cancel=true
				local tpe=tc:GetType()
				local te=tc:GetActivateEffect()
				local co=te:GetCost()
				local tg=te:GetTarget()
				local op=te:GetOperation()
				e:SetCategory(te:GetCategory())
				e:SetProperty(te:GetProperty())
				Duel.MoveToField(tc,tp,tp,LSTN("S"),POS_FACEUP,true)
				Duel.HintActivation(te)
				e:SetActiveEffect(te)
				if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)<1 then
					tc:CancelToGrave(false)
					if Duel.GetCurrentChain()<1 then
						cancel=false
					end
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
				if op then
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
				if not cancel then
					Duel.SendtoGrave(tc,REASON_RULE)
				end
			end
		end
		c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1,1)
	end
	if b2 then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,2)
		e1:SetValue(c:GetBaseAttack()*2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(c:GetBaseDefense()*2)
		c:RegisterEffect(e2)
		local e3=MakeEff(c,"S")
		e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,2)
		e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
		e3:SetCondition(cm.ocon83)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1,2)
	end
end
function cm.ocon83(e)
	local c=e:GetHandler()
	return c:GetBattleTarget()~=nil
end