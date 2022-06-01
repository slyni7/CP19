--Arom@$er@phy - Ro$em@ry
local m=18453195
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.pfil1,nil,nil,nil,1,99,cm.pfun1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.con1)
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
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetTR("M",0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2e6))
	e6:SetCondition(cm.con6)
	e6:SetValue(cm.val6)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	e7:SetValue(cm.val7)
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"FC","M")
	e8:SetCode(EVENT_RECOVER)
	WriteEff(e8,8,"O")
	c:RegisterEffect(e8)
end
cm.square_mana={0x0,0x0,ATTRIBUTE_LIGHT,0x0,0x0}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.pfil1(c)
	return c:IsSynchroType(TYPE_TUNER) and c:IsSetCard(0x2e6)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
function cm.con1(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
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
function cm.val6(e,c)
	return math.ceil(c:GetAttack()/2)
end
function cm.val7(e,c)
	return math.ceil(c:GetDefense()/2)
end
function cm.ofil8(c)
	return c:IsSetCard(0x2e6) and c:IsFaceup()
end
function cm.op8(e,tp,eg,ep,ev,re,r,rp)
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
	local g1=Duel.GMGroup(cm.ofil8,tp,"O",0,nil,1)
	if b1 and #g1>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=g1:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		local tc=tg:GetFirst()
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(cm.oval81)
		tc:RegisterEffect(e1)
		c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1,1)
	end
	local g2=Duel.GMGroup(aux.disfilter1,tp,0,"O",nil)
	if b2 and #g2>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=g2:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		local tc=tg:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=MakeEff(c,"S")
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1,2)
	end
end
function cm.oval81(e,re)
	return e:GetHandler()~=re:GetOwner()
end