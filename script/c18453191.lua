--Arom@ge - C@n@ng@
local m=18453191
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
	e6:SetCode(EFFECT_SET_ATTACK)
	e6:SetTR(0,"M")
	e6:SetCondition(cm.con6)
	e6:SetValue(cm.val6)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_SET_DEFENSE)
	e7:SetValue(cm.val7)
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"FC","M")
	e8:SetCode(EVENT_ADJUST)
	WriteEff(e8,8,"O")
	c:RegisterEffect(e8)
	local e9=MakeEff(c,"FC","M")
	e9:SetCode(EVENT_RECOVER)
	WriteEff(e9,9,"O")
	c:RegisterEffect(e9)
end
cm.square_mana={ATTRIBUTE_EARTH,ATTRIBUTE_EARTH,ATTRIBUTE_EARTH}
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
function cm.val6(e,c)
	local h=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local fid=h:GetFieldID()
	local atk=c:GetAttack()
	local val=math.floor(atk/math.floor(Duel.GetLP(tp)/Duel.GetLP(1-tp))+1/2)
	if atk>val and h:GetAttack()>val and not c:IsImmuneToEffect(e) then
		local e1=MakeEff(h,"S")
		e1:SetCode(m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabel(fid)
		c:RegisterEffect(e1)
	end
	return val
end
function cm.val7(e,c)
	local h=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local fid=h:GetFieldID()
	local def=c:GetDefense()
	local val=math.floor(def/math.floor(Duel.GetLP(tp)/Duel.GetLP(1-tp))+1/2)
	if def>val and h:GetAttack()>val and not c:IsImmuneToEffect(e) then
		local e1=MakeEff(h,"S")
		e1:SetCode(m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabel(fid)
		c:RegisterEffect(e1)
	end
	return val
end
function cm.ofil8(c,fid)
	if c:IsFacedown() then
		return false
	end
	for _,te in ipairs({c:IsHasEffect(m)}) do
		local label=te:GetLabel()
		if label==fid then
			return true
		end
	end
	return false
end
function cm.op8(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local g=Duel.GMGroup(cm.ofil8,tp,"M","M",nil,fid)
	local tc=g:GetFirst()
	while tc do
		for _,te in ipairs({c:IsHasEffect(m)}) do
			local label=te:GetLabel()
			if label==fid then
				te:Reset()
			end
		end
		tc=g:GetNext()
	end
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.ofil91(c,e,tp)
	return ((c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocCount(tp,"M")>0) or c:IsAbleToHand())
		and c:IsSetCard(0x2e6) and c:IsType(TYPE_MONSTER) and not c:IsCode(m)
end
function cm.ofil92(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function cm.op9(e,tp,eg,ep,ev,re,r,rp)
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
	local g1=Duel.GMGroup(cm.ofil91,tp,"D",0,nil,e,tp)
	if b1 and #g1>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g1:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) or Duel.GetLocCount(tp,"M")<1
				or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			end
		end
		c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1,1)
	end
	local g2=Duel.GMGroup(cm.ofil92,tp,0,"O",nil)
	if b2 and #g2>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=g2:Select(tp,1,1,nil)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1,2)
	end
end