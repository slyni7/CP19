--[ Tinnitus ]
local m=99970415
local cm=_G["c"..m]
function cm.initial_effect(c)

	--타깃 설정
	local e0=MakeEff(c,"FC","M")
	e0:SetCode(EVENT_ADJUST)
	WriteEff(e0,0,"NO")
	c:RegisterEffect(e0)

	--특수 소환
	local e1=MakeEff(c,"Qo","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--드로우 + 파괴
	local e2=MakeEff(c,"FTo","M")
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCL(1,YuL.S)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCL(1,YuL.S)
	WriteEff(e3,2,"T")
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)

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

--특수 소환
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1e1c,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1e1c,1,REASON_COST)
	if Duel.IsCanRemoveCounter(tp,1,1,0x1e1c,1,REASON_COST) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.RemoveCounter(tp,1,1,0x1e1c,1,REASON_COST)
	end
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--드로우 + 파괴
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetCounter(0x1e1c)>0
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 and at:IsRelateToBattle() and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:GetHandler():GetCounter(0x1e1c)>0
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 and re:GetHandler():IsRelateToEffect(re) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
