--[ hololive Gamers ]
local m=99970684
local cm=_G["c"..m]
function cm.initial_effect(c)

	YuL.Activate(c)
	
	--Yubi Yubi!
	local e1=MakeEff(c,"Qo","S")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
	--파괴
	local e2=MakeEff(c,"Qo","S")
	e2:SetD(m,1)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)

end

--Yubi Yubi!
function cm.con1fil(c)
	return c:IsFaceup() and c:IsCode(m-2)
end
function cm.con1(e)
	return Duel.IsExistingMatchingCard(cm.con1fil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function cm.tar1fil(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tar1fil(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar1fil,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,cm.tar1fil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,g:GetFirst():GetLevel(),0,0x1d66)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsFaceup() and tc:GetLevel()>0 then
		c:AddCounter(0x1d66,tc:GetLevel())
	end
end

--파괴
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1d66,20,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1d66,20,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
