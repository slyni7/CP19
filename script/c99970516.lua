--Nosmirc Sorrow
local m=99970516
local cm=_G["c"..m]
function cm.initial_effect(c)

	--함정 몬스터
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	WriteEff(e0,0,"TO")
	c:RegisterEffect(e0)
	
	--패 발동
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e10:SetCondition(cm.handcon)
	c:RegisterEffect(e10)
	
	--Nosmirc
	local e20=MakeEff(c,"FTf","M")
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
	
	--전투 내성 / 직접 공격 제약
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	WriteEff(e1,1,"N")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	--공수 증가
	local e3=MakeEff(c,"FTo","M")
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCL(1)
	WriteEff(e3,1,"N")
	WriteEff(e3,3,"CO")
	c:RegisterEffect(e3)

end

--함정 몬스터
M_atk,M_def=1000,1000
function cm.tar0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
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
	if not Duel.IsPlayerCanDraw(p,2) then return end
	local ac=2
	if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)>2 then
		Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(m,0))
		ac=Duel.AnnounceNumber(p,2,3)
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

--전투 내성 / 직접 공격 제약
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end

--공수 증가
function cm.cfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),0x20004)==0x20004 and c:IsSetCard(0xe0d) and c:IsAbleToHandAsCost()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(c:GetDefense()*2)
		c:RegisterEffect(e2)
	end
end
