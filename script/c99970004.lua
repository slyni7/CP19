--[ Module 2 ]
local m=99970004
local cm=_G["c"..m]
function cm.initial_effect(c)

	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,cm.mod1,cm.mod2,2,99,nil)
	
	--장착
	local e1=MakeEff(c,"FTo","M")
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(spinel.delay)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--드로우
	local e2=MakeEff(c,"I","M")
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCL(1,m)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	
	--공수 증감
	local e3=MakeEff(c,"FC","M")
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCL(1)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
end

--모듈 소환
function cm.mod1(c)
	return not c:IsStatus(STATUS_SPSUMMON_TURN)
end
function cm.mod2(c)
	return c:IsEquipTurn()
end

--장착
function cm.cfilter(c,tp)
	return c:GetSummonPlayer()==1-tp and c:IsAbleToChangeControler()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.cfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=g:GetCount() end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_MZONE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=g:GetCount() or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end

--드로우
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mx=2
	if not (Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2)) then mx=1 end
	local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,mx,nil)
	local ct=Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(ct)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Draw(tp,ct,REASON_EFFECT)
	Duel.Draw(1-tp,ct,REASON_EFFECT)
end

--공수 증감
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=300
	if c:GetEquipCount()==0 then atk=-300 end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
