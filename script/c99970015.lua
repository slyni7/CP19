--[ Module 2 ]
local m=99970015
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c,nil,aux.FBF(Card.IsSetCard,0xe1d))

	--싱크로 변경
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_MODULE)
	c:RegisterEffect(e1)
 	
	--레벨 변경
	local e2=MakeEff(c,"I","S")
	e2:SetCL(1)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)

end

--레벨 변경
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local lv=2
	local op=0
	if not ec:IsLevel(1) then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		if op==1 then lv=-2 end
	end
	if ec and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
		
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_MODULE_MATERIAL)
		e2:SetValue(1)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
