--시엘 이리데센트
local m=99000399
local cm=_G["c"..m]
function cm.initial_effect(c)
	--order summon
	aux.AddOrderProcedure(c,"R",nil,cm.ordfil1,aux.FilterBoolFunction(Card.IsSummonType,SUMMON_TYPE_SPECIAL))
	c:EnableReviveLimit()
	--att change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMING_BATTLE_PHASE)
	e1:SetCondition(cm.attcon)
	e1:SetTarget(cm.atttg)
	e1:SetOperation(cm.attop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCountLimit(1,m+10000)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.eqcon)
	e3:SetTarget(cm.eqtg)
	e3:SetOperation(cm.eqop)
	c:RegisterEffect(e3)
end
cm.CardType_Order=true
function cm.ordfil1(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()~=LOCATION_EXTRA
end
function cm.attcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and not e:GetHandler():IsStatus(STATUS_CHAINING)
		and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler())
end
function cm.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local aat=Duel.AnnounceAttribute(tp,1,0xff-e:GetHandler():GetAttribute())
	e:SetLabel(aat)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE,0,1)
end
function cm.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)	
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e2,tp)
end
function cm.disfilter1(c)
	return c:GetFlagEffect(m+50000)~=0
end
function cm.disfilter2(c,rc,tp)
	if c:IsFaceup() then
		local att=rc:GetAttribute()
		for gc in aux.Next(rc:GetEquipGroup():Filter(cm.disfilter1,nil)) do
			att=att|gc:GetAttribute()
		end
		return c:IsFaceup() and c:GetAttribute()&att~=0
	end
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.disfilter2(chkc,e:GetHandler(),tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.disfilter2,tp,0,LOCATION_MZONE,1,nil,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,cm.disfilter2,tp,0,LOCATION_MZONE,1,1,nil,e:GetHandler(),tp)
end
function cm.eqfilter(c)
	return (c:IsFaceup() or c:GetEquipTarget()) and c:IsType(TYPE_EQUIP)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local ct=Duel.GetMatchingGroupCount(cm.eqfilter,tp,LOCATION_ONFIELD,0,nil)
		if ct>0 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetValue(-ct*1000)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end
function cm.cfilter(c,rc,tp)
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==1-tp
		and c:IsType(TYPE_MONSTER) and c:GetAttribute()&rc:GetAttribute()~=0
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,e:GetHandler(),tp)
end
function cm.chkfilter(c,tp)
	return not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function cm.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==1-tp
		and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE) and cm.chkfilter(c,tp)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.filter,nil,tp)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=#g end
	Duel.SetTargetCard(g)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(aux.NecroValleyFilter(cm.chkfilter),nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsFaceup() and c:IsRelateToEffect(e) and #g>0 and ft>0 then
		local sg=nil
		if #g>ft then
			sg=g:Select(tp,ft,ft,nil)
		else
			sg=g
		end
		local tc=sg:GetFirst()
		while tc do
			if Duel.Equip(tp,tc,c,true,true) then
				tc:RegisterFlagEffect(m+50000,RESET_EVENT+RESETS_STANDARD,0,0)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.eqlimit)
				tc:RegisterEffect(e1)
			end
			tc=sg:GetNext()
		end
		Duel.EquipComplete()
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end