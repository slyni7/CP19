--Desruc Nosmirc
local m=99970520
local cm=_G["c"..m]
function cm.initial_effect(c)

	--함정 몬스터
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	WriteEff(e0,0,"CTO")
	c:RegisterEffect(e0)
	
	--패 발동
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e10:SetCondition(cm.handcon)
	c:RegisterEffect(e10)
	
	--Nosmirc
	local e20=MakeEff(c,"FTf","M")
	e20:SetD(m,1)
	e20:SetCategory(CATEGORY_DRAW)
	e20:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e20:SetCode(EVENT_PHASE+PHASE_END)
	e20:SetCL(1)
	WriteEff(e20,20,"NTO")
	c:RegisterEffect(e20)
	
	--Fallen
	local e30=MakeEff(c,"STf")
	e30:SetCode(EVENT_TO_GRAVE)
	WriteEff(e30,30,"NTO")
	c:RegisterEffect(e30)

	--드로우
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(m,2)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(spinel.relcost)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
	--공수 감소
	local e2=MakeEff(c,"STo")
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(spinel.delay)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)

end

--함정 몬스터
M_atk,M_def=2600,2200
function cm.mzfilter(c,tp)
	return c:GetSequence()<5
end
function cm.cfilter(c)
	return c:IsSetCard(0xe0d) and c:IsAbleToRemoveAsCost()
end
function cm.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if chk==0 then return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(cm.mzfilter,ct,nil,tp)) end
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=rg:Select(tp,2,2,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=rg:FilterSelect(tp,cm.mzfilter,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=rg:FilterSelect(tp,cm.mzfilter,2,2,nil,tp)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tar0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe0d,0x21,M_atk,M_def,10,RACE_FIEND,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xe0d,0x21,M_atk,M_def,10,RACE_FIEND,ATTRIBUTE_FIRE) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP)
end

--패 발동
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==1
end

--Nosmirc
function cm.con20(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1 and Duel.GetTurnPlayer()~=tp
end
function cm.tar20(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function cm.op20(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if not Duel.IsPlayerCanDraw(p,3) then return end
	local ac=3
	if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)>3 then
		Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(m,0))
		ac=Duel.AnnounceNumber(p,3,4)
	end
	local dr=Duel.Draw(p,ac,REASON_EFFECT)
	if p~=tp and dr~=0 then
		local dmg=dr*500
		Duel.BreakEffect()
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-dmg)
	end
end

--Fallen
function cm.con30(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_ADJUST)~=0
end
function cm.setfil(c)
	return c:IsCode(99970511) and c:IsSSetable()
end
function cm.tar30(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingMatchingCard(cm.setfil,tp,LSTN("DG"),0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.op30(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.setfil,tp,LSTN("DG"),0,1,1,nil)
		if #g>0 then
			Duel.SSet(tp,g)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

--드로우
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local d1=Duel.Draw(tp,1,REASON_EFFECT)
	local d2=Duel.Draw(1-tp,1,REASON_EFFECT)
	if d1==0 or d2==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end

--공수 감소
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1 and Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local d=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-d)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
	end
end
