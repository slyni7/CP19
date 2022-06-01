--오버 더 LV(레벨)!
local m=99000240
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.operation2)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsFaceup() and (c:GetLevel()>0 or c:GetRank()>0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.cfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		if tc:IsType(TYPE_XYZ) then
			e1:SetCode(EFFECT_UPDATE_RANK)
		else e1:SetCode(EFFECT_UPDATE_LEVEL) end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(10)
		tc:RegisterEffect(e1)
		local tg=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_EXTRA,nil)
		if tg:GetCount()==0 then return end
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local ctlv=g:GetSum(Card.GetLevel)
		local ctrk=g:GetSum(Card.GetRank)
		local ct=(ctlv+ctrk)/20
		local ct1=math.floor(ct+0.5)
		local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
		if ct1>ct2 then ct1=ct2 end
		local t={}
		for i=1,ct1 do t[i]=i end
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			local tc=tg:RandomSelect(tp,ct1)
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function cm.filter2(c)
	return c:IsFaceup() and (c:GetOriginalLevel()>=10 or c:GetOriginalRank()>=10)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		if tc:IsType(TYPE_XYZ) then
			e1:SetCode(EFFECT_UPDATE_RANK)
		else e1:SetCode(EFFECT_UPDATE_LEVEL) end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(20)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,1))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(cm.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		--atk/def down
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetValue(cm.atkval)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e4)
		if not tc:IsType(TYPE_EFFECT) then
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_ADD_TYPE)
			e5:SetValue(TYPE_EFFECT)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e5,true)
		end
	end
end
function cm.efilter(e,te)
	if e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true end
	if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
		if e:GetHandler():IsType(TYPE_XYZ) then
			lv=e:GetHandler():GetRank()
		else lv=e:GetHandler():GetLevel() end
		local ec=te:GetOwner()
		if ec:IsType(TYPE_LINK) then
			return false
		elseif ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<lv
		else
			return ec:GetOriginalLevel()<lv
		end
	else
		return false
	end
end
function cm.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local ctlv=g:GetSum(Card.GetLevel)
	local ctrk=g:GetSum(Card.GetRank)
	local ct=(ctlv+ctrk)*20
	return -ct
end