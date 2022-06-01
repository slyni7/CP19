--[ Pioneer ]
local m=99970595
local cm=_G["c"..m]
function cm.initial_effect(c)

	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,cm.mfilter,nil,1,99,nil)

	--공격력 감소
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	
	--바운스
	local e1=MakeEff(c,"Qo","M")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
end

--모듈 소환
function cm.mfilter(c)
	return c:IsCode(99970591) and c:IsAttribute(ATT_W)
end

--공격력 감소
function cm.atkval(e,c)
	return math.abs(Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND))*-1000
end

--바운스
function cm.filter(c,e)
	return c:IsPosition(POS_FACEUP) and c:GetAttack()~=c:GetBaseAttack()
		and c:IsCanBeEffectTarget(e)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,e) end
	if chk==0 then
		--retain applicable targets in case cost makes an indirect change to ATK
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
		if #g==0 or not Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then return end
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=e:GetLabelObject()
	local sg=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
