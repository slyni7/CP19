--[ Pneumamancy ]
local m=99970379
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	local e1=YuL.Equip(c,nil,aux.FBF(Card.IsSetCard,0xe12),nil,nil,nil,cm.pneu_op)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)

	--공격력 배가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	
end

--영령술
function cm.filter(c,g)
	return c:IsFaceup() and not (c:IsAttack(0) and c:IsDefense(0)) and g:IsContains(c)
end
function cm.pneu_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local cg=c:GetColumnGroup()
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil,cg)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end

--공격력 배가
function cm.atkval(e,c)
	return c:GetBaseAttack()*2
end
