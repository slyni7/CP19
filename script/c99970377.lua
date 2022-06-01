--[ Pneumamancy ]
local m=99970377
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	local e1=YuL.Equip(c,nil,aux.FBF(Card.IsSetCard,0xe12),nil,nil,cm.pneu_tg,cm.pneu_op)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_DISABLE)

	--직접 공격
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	
end

--영령술
function cm.filter(c,g)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT+TYPE_SPELL+TYPE_TRAP) and not c:IsDisabled() and g:IsContains(c)
end
function cm.pneu_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local cg=c:GetColumnGroup()
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil,cg)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
			tc=g:GetNext()
		end
	end
end
