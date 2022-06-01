--[ Tinnitus ]
local m=99970412
local cm=_G["c"..m]
function cm.initial_effect(c)

	--타깃 설정
	local e0=MakeEff(c,"FC","M")
	e0:SetCategory(CATEGORY_COUNTER)
	e0:SetCode(EVENT_ADJUST)
	WriteEff(e0,0,"NO")
	c:RegisterEffect(e0)
	
	--무효 + 카운터
	local e1=MakeEff(c,"Qo","M")
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,m)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon)
	c:RegisterEffect(e2)

end

--타깃 설정
function cm.con0fil(c)
	return c:GetCounter(0x1e1c)>0
end
function cm.con0(e)
	return not Duel.IsExistingMatchingCard(cm.con0fil,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(cm.op0fil,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil,e)
end
function cm.op0fil(c,e)
	return not c:IsImmuneToEffect(e) and c:IsFaceup()
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.op0fil,tp,0,LOCATION_MZONE,nil,e)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,m)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		sg:GetFirst():AddCounter(0x1e1c,1,REASON_EFFECT)
	end
end

--무효 + 카운터
function cm.con1()
	return Duel.IsMainPhase()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1e1c,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1e1c,2,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			tc:AddCounter(0x1e1c,1,REASON_EFFECT)
		end
	end
end

--특수 소환
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(cm.con0fil,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
