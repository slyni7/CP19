--[ Module 2 ]
local m=99970006
local cm=_G["c"..m]
function cm.initial_effect(c)

	--레벨 증가
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(spinel.delay)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	
	--장착
	local e2=MakeEff(c,"I","M")
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_TOKEN)
	e2:SetCountLimit(3,m)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
end

--레벨 증가
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e2:SetValue(3)
		c:RegisterEffect(e2)
	end
end

--장착
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLevelAbove(3) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or c:IsLevelBelow(2) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-2)
	c:RegisterEffect(e1)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local token=Duel.CreateToken(tp,99970007)
		Duel.Equip(tp,token,c)
	end
end
