--베노퀄리아 렙트로직
--카드군 번호: 0xc94
local m=81264090
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--묘지 유발
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cn2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--발동시
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,0x02,0,nil)<=2
end
function cm.tfil0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xc94)
end
function cm.tgfil1(c)
	return c:IsFaceup() and ( c:GetAttack()>0 or c:GetDefense()>0 )
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x0c+0x02,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(cm.tgfil1,tp,0,0x04,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x0c)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x0c+0x02,0,1,1,e:GetHandler())
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local sg=Duel.GetMatchingGroup(cm.tgfil1,tp,0,LOCATION_MZONE,nil)
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_EFFECT) and not tc:IsDisabled() then
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_DISABLE_EFFECT)
				tc:RegisterEffect(e4)
			end
			tc=sg:GetNext()
		end
	end
end

--묘지 유발
function cm.nfil0(c,tp)
	return c:GetType()&0x1+TYPE_RITUAL==0x1+TYPE_RITUAL and c:IsReason(REASON_EFFECT)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil0,1,nil,tp)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tgfil1,tp,0x04,0x04,1,nil)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,cm.tgfil1,tp,0x04,0x04,1,1,nil):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		tc:RegisterEffect(e2)
	end
end

