--[ Module 2 ]
local m=99970008
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
end

--장착
function cm.filter2(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and Duel.IsExistingMatchingCard(cm.eqfilter2,tp,LOCATION_GRAVE,0,1,nil,tp)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=0
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter2(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft
		and Duel.IsExistingTarget(cm.filter2,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
	Duel.SelectTarget(tp,cm.filter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,cm.eqfilter2,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		if g:GetCount()>0 and Duel.Equip(tp,g:GetFirst(),tc)~=0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			g:GetFirst():RegisterEffect(e1)
		end
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetOperation(cm.desop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		tc:RegisterEffect(e3)
	end
end
function cm.eqfilter2(c,tp)
	return c:IsRace(RACE_PLANT) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
