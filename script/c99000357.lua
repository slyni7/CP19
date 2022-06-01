--OVER_LEVEL@SPELL
local m=99000357
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,99000355)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.rmcost)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	--over level
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.ovlvtg)
	e2:SetOperation(cm.ovlvop)
	c:RegisterEffect(e2)
end
function cm.spell_filter(c)
	return c:IsSetCard(0xc13) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spell_filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.spell_filter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function cm.rfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(cm.rfilter,tp,0,LOCATION_EXTRA,nil)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local ctlv=g:GetSum(Card.GetLevel)
	local ctrk=g:GetSum(Card.GetRank)
	if chk==0 then return tg:GetCount()>0 and ctlv+ctrk>0 end
	local ct=(ctlv+ctrk)/5
	local ct1=math.floor(ct+0.5)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
	if ct1>ct2 then ct1=ct2 end
	e:SetLabel(ct1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct1,1-tp,LOCATION_EXTRA)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(cm.rfilter,tp,0,LOCATION_EXTRA,nil)
	if tg==0 then return end
	local ct1=e:GetLabel()
	local t={}
	for i=1,ct1 do t[i]=i end
	local tc=tg:RandomSelect(tp,ct1)
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
end
function cm.ovlvfilter(c)
	return c:IsFaceup() and c:IsCode(99000355)
end
function cm.ovlvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.ovlvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.ovlvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.ovlvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.ovlvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(50)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK)
		e2:SetValue(5000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_SET_DEFENSE)
		tc:RegisterEffect(e3)
		--cannot release
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_UNRELEASABLE_SUM)
		e4:SetValue(1)
		tc:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e5)
		--
		local ea=Effect.CreateEffect(c)
		ea:SetDescription(aux.Stringid(m,1))
		ea:SetType(EFFECT_TYPE_SINGLE)
		ea:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
		ea:SetRange(LOCATION_MZONE)
		ea:SetCode(EFFECT_IMMUNE_EFFECT)
		ea:SetValue(cm.efilter)
		ea:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(ea)
		--atk/def down
		local eb=Effect.CreateEffect(c)
		eb:SetType(EFFECT_TYPE_FIELD)
		eb:SetCode(EFFECT_UPDATE_ATTACK)
		eb:SetRange(LOCATION_MZONE)
		eb:SetTargetRange(0,LOCATION_MZONE)
		eb:SetValue(cm.atkval)
		eb:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(eb)
		local ec=eb:Clone()
		ec:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(ec)
		--indes
		local ed=Effect.CreateEffect(c)
		ed:SetDescription(aux.Stringid(m,2))
		ed:SetProperty(EFFECT_FLAG_CARD_TARGET)
		ed:SetType(EFFECT_TYPE_QUICK_O)
		ed:SetRange(LOCATION_MZONE)
		ed:SetCountLimit(1)
		ed:SetCode(EVENT_FREE_CHAIN)
		ed:SetTarget(cm.indestg)
		ed:SetOperation(cm.indesop)
		ed:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(ed)
		if not tc:IsType(TYPE_EFFECT) then
			local ee=Effect.CreateEffect(c)
			ee:SetType(EFFECT_TYPE_SINGLE)
			ee:SetCode(EFFECT_ADD_TYPE)
			ee:SetValue(TYPE_EFFECT)
			ee:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(ee,true)
		end
	end
end
function cm.efilter(e,te)
	if e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true end
	if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
		local lv=e:GetHandler():GetLevel()
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
function cm.indes_filter(c)
	return c:IsFaceup()
end
function cm.indestg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and cm.indes_filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.indes_filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.indes_filter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function cm.indesop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetValue(cm.valcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function cm.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end