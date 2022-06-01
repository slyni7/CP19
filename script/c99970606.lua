--[ RainbowFish ]
local m=99970606
local cm=_G["c"..m]
function cm.initial_effect(c)

	--엑시즈 소환
	RevLim(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRainbowFishCard),4,2)

	--레인보우 휘시 밀렵이다.
	local e1=MakeEff(c,"STo")
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCL(1,m)
	e1:SetCondition(spinel.stypecon(SUMMON_TYPE_XYZ))
	WriteEff(e1,1,"CO")
	c:RegisterEffect(e1)
	
	--무효화
	local e2=MakeEff(c,"Qo","M")
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCL(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	
	--직접 공격 부여
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_DIRECT_ATTACK)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetCondition(cm.con0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsRainbowFish))
	c:RegisterEffect(e0)
	
end

--레인보우 휘시 밀렵이다.
function cm.thfilter(c)
	return c:IsRainbowFish() and c:IsAbleToRemoveAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Group.CreateGroup()
	for i=1,4 do
		local token=Duel.CreateToken(tp,CARD_RAINBOW_FISH)
		g:AddCard(token)
	end
	Duel.DisableShuffleCheck()
	Duel.SendtoDeck(g,nil,1,REASON_RULE)
	Duel.Overlay(c,g)
end

--무효화
function cm.cfil2(c)
	return c:IsAbleToRemoveAsCost() and c:IsRainbowFish()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.cfil2,tp,LSTN("G"),0,nil)
	mg:Merge(e:GetHandler():GetOverlayGroup():Filter(cm.cfil2,nil))
	if chk==0 then return #mg>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=mg:Select(tp,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--무효화
function cm.filter(c)
	return c:IsFaceup() and (c:IsType(TYPE_EFFECT) or c:IsType(TYPE_SPELL+TYPE_TRAP)) and not c:IsDisabled()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end

--직접 공격 부여
function cm.con0(e)
	return e:GetHandler():GetOverlayCount()>=3
end
