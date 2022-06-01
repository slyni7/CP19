--[KATANAGATARI]
local m=99970323
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c,nil,cm.eqfil)

	--완료형 변체도 야스리 시치카
	local e0=MakeEff(c,"I","S")
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e0,0,"CTO")
	c:RegisterEffect(e0)

	--허도류
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e01:SetRange(LOCATION_MZONE)
	e01:SetCode(EFFECT_IMMUNE_EFFECT)
	e01:SetValue(cm.efilter)
	WriteEff(e01,0,"N")
	c:RegisterEffect(e01)
	
	--수집완료
	local e02=MakeEff(c,"I","M")
	e02:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e02:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e02:SetCountLimit(1)
	e02:SetTarget(cm.tar02)
	e02:SetOperation(cm.op02)
	WriteEff(e02,0,"N")
	c:RegisterEffect(e02)
	
	--토가메의 칼
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetTarget(cm.distarget)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(cm.disoperation)
	c:RegisterEffect(e4)
	
end

--장착
function cm.eqfil(c)
	return c:IsCode(99970326)
end

--완료형 변체도 야스리 시치카
function cm.cfil(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xe08) and (c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) or c:IsFaceup())
end
function cm.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local sg=Duel.GetMatchingGroup(cm.cfil,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return sg:GetCount()>=12 and (ft>0 or sg:IsExists(Card.IsLocation,ct,nil,LOCATION_MZONE)) end
	local g=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<12 then
			sg:Sub(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g1=sg:Select(tp,12-ct,12-ct,nil)
			g:Merge(g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=sg:Select(tp,12,12,nil)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tar0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LSTN("M"))>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe08,TYPE_MONSTER+TYPE_EFFECT,3000,2000,7,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LSTN("M"))<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe08,TYPE_MONSTER+TYPE_EFFECT,3000,2000,7,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,1,tp,tp,true,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end

--효과 적용
function cm.con0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end

--허도류
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_EQUIP)
end

--수집완료
function cm.thfilter(c)
	return c:IsSetCard(0xe08) and c:IsAbleToHand()
end
function cm.tar02(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function cm.op02(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)
		and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end

--토가메의 칼
function cm.distarget(e,c)
	local tc=e:GetHandler():GetEquipTarget()
	return tc~=nil and tc:GetEquipGroup():IsContains(c) and c~=e:GetHandler()
end
function cm.disoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tc~=nil and bit.band(tl,LOCATION_SZONE)~=0 and tc:GetEquipGroup():IsContains(re:GetHandler()) and re:GetHandler()~=e:GetHandler() then
		Duel.NegateEffect(ev)
	end
end
