--[ Module 2 ]
local m=99970014
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c,nil,cm.eqfil)
	
	--복사
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.cptg)
	e2:SetOperation(cm.cpop)
	c:RegisterEffect(e2)
	
end

--장착
function cm.eqfil(c)
	return c:GetEquipCount()>0
end

--복사
function cm.cpfilter(c,tc)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and not c:IsCode(m) and c:GetEquipTarget()==tc
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=e:GetHandler():GetEquipTarget()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and cm.cpfilter(chkc,tc) end
	if chk==0 then return Duel.IsExistingTarget(cm.cpfilter,tp,LOCATION_SZONE,0,1,nil,tc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.cpfilter,tp,LOCATION_SZONE,0,1,1,nil,tc)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end
