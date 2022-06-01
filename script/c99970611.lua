--[ RainbowFish ]
local m=99970611
local cm=_G["c"..m]
function cm.initial_effect(c)

	--엑시즈 소환
	RevLim(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATT_W),4,3,cm.ovfilter,aux.Stringid(m,0))

	--묘지 회수 + 공수 증가
	local e2=MakeEff(c,"STf")
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(spinel.stypecon(SUMMON_TYPE_XYZ))
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--파괴
	local e1=MakeEff(c,"I","G")
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCL(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)

	--효과 파괴 내성
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(cm.indcon)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	
end

--엑시즈 소환
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATT_W) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>=3
end

--묘지 회수 + 공수 증가
function cm.fil2(c)
	return c:IsAttribute(ATT_W) and c:IsFaceup()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.fil2,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		local ct=Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
		if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*300)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end
end

--파괴
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetOverlayGroup(tp,1,1):Filter(Card.IsAbleToRemoveAsCost,nil)
	if chk==0 then return #mg>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=mg:Select(tp,1,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(#g)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,e:GetLabel(),0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

--효과 파괴 내성
function cm.indcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
