--Arom@ge - Ro$em@ry
local m=18453190
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
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
	e6:SetCode(EFFECT_PUBLIC)
	e6:SetTR("H",0)
	e6:SetCondition(cm.con6)
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"F","M")
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetTR("HOG",0)
	e7:SetCondition(cm.con6)
	e7:SetTarget(cm.tar7)
	e7:SetValue(cm.val7)
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"FC","M")
	e8:SetCode(EVENT_RECOVER)
	WriteEff(e8,8,"O")
	c:RegisterEffect(e8)
end
cm.square_mana={ATTRIBUTE_WATER,ATTRIBUTE_WATER,ATTRIBUTE_WATER,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
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
function cm.tar7(e,c)
	return (c:IsSetCard(0x2e6) or c:IsSetCard("Æ÷¼Ç")) and not c:IsCode(m)
end
function cm.val7(e,re)
	return e:GetOwnerPlayer()~=re:GetHandlerPlayer()
end
function cm.ofil8(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	return ((te and te:IsActivatable(tp) and (Duel.GetLocCount(tp,"S")>0 or c:IsType(TYPE_FIELD))) or c:IsAbleToHand())
		and c:IsSetCard(0x2e6) and c:IsType(TYPE_SPELL)
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
	local g1=Duel.GMGroup(cm.ofil8,tp,"D",0,nil,tp)
	if b1 and #g1>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local tg=g1:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:CheckActivateEffect(false,false,false)
				or not tc:CheckActivateEffect(false,false,false):IsActivatable(tp)
				or (Duel.GetLocCount(tp,"S")<1 and not tc:IsType(TYPE_FIELD))
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
				if tc:IsType(TYPE_FIELD) then
					Duel.MoveToField(tc,tp,tp,LSTN("F"),POS_FACEUP,true)
				else
					Duel.MoveToField(tc,tp,tp,LSTN("S"),POS_FACEUP,true)
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
			end
		end
		c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1,1)
	end
	local g2=Duel.GMGroup(Card.IsFaceup,tp,0,"M",nil)
	if b2 and #g2>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=g2:Select(tp,1,1,nil)
		if Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE)==0 then
			Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
		end
		c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1,2)
	end
end