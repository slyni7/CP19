--[ RainbowFish ]
local m=99970610
local cm=_G["c"..m]
function cm.initial_effect(c)

	--패 발동
	local ez=Effect.CreateEffect(c)
	ez:SetType(EFFECT_TYPE_SINGLE)
	ez:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	ez:SetCondition(cm.handcon)
	c:RegisterEffect(ez)
	
	--으악! 레인보우 휘시 군단이다!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--공수 증가
	local e2=MakeEff(c,"Qo","G")
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCost(aux.bfgcost)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

--패 발동
function cm.handcon(e)
	return Duel.GetOverlayGroup(e:GetHandlerPlayer(),1,1):Filter(Card.IsRainbowFish,nil):GetCount()>=10
end

--으악! 레인보우 휘시 군단이다!
function cm.cfil1(c)
	return c:IsAbleToRemoveAsCost() and c:IsRainbowFish()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.cfil1,tp,LSTN("HG"),0,nil)
	mg:Merge(Duel.GetOverlayGroup(tp,1,1):Filter(cm.cfil1,nil))
	if chk==0 then return #mg>6 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=mg:Select(tp,7,7,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local oft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return
		(ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,CARD_RAINBOW_FISH,0,TYPE_MONSTER+TYPE_NORMAL,1800,800,4,RACE_FISH,ATTRIBUTE_WATER))
		or (oft>0 and Duel.IsPlayerCanSpecialSummonMonster(1-tp,CARD_RAINBOW_FISH,0,TYPE_MONSTER+TYPE_NORMAL,1800,800,4,RACE_FISH,ATTRIBUTE_WATER)) end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		if ft==0 then oft=1 
		elseif ft==1 then oft=0 end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft+oft,tp,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local oft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if not
		((ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,CARD_RAINBOW_FISH,0,TYPE_MONSTER+TYPE_NORMAL,1800,800,4,RACE_FISH,ATTRIBUTE_WATER)) or (oft>0 and Duel.IsPlayerCanSpecialSummonMonster(1-tp,CARD_RAINBOW_FISH,0,TYPE_MONSTER+TYPE_NORMAL,1800,800,4,RACE_FISH,ATTRIBUTE_WATER))) then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		if ft==0 then oft=1
		elseif oft==0 then ft=1
		else ft=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1)) oft=1-ft end
	end
	for i=1,ft do
		local token=Duel.CreateToken(tp,CARD_RAINBOW_FISH)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	for z=1,oft do
		local tokeno=Duel.CreateToken(tp,CARD_RAINBOW_FISH)
		Duel.SpecialSummonStep(tokeno,0,tp,1-tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end

--공수 증가
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) and aux.exccon(e)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsRainbowFishCard()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
