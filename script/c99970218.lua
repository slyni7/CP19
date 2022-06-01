--Mystic Orchestra XIII 「Peace」
local m=99970218
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Mystic Orchestra
	local e1=YuL.ActST(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--함정 무효
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LSTN("S"),LSTN("S"))
	e2:SetTarget(cm.distarget)
	WriteEff(e2,0,"N")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","M")
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetOperation(cm.disop)
	WriteEff(e3,0,"N")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","M")
	e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e4:SetTargetRange(LSTN("M"),LSTN("M"))
	e4:SetTarget(cm.distarget)
	WriteEff(e4,0,"N")
	c:RegisterEffect(e4)
	
	--무효 + 바운스
	local e5=MakeEff(c,"Qo","M")
	e5:SetCategory(CATEGORY_NEGATE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCountLimit(1)
	WriteEff(e5,5,"NCTO")
	c:RegisterEffect(e5)
	
end

--Info
cm.mystic_orchestra_num=8
M_level=8
M_att=ATTRIBUTE_WIND
M_atk=800
M_def=2700
M_type=TYPE_MONSTER+TYPE_EFFECT+TYPE_RITUAL

--Mystic Orchestra
function cm.mysticfil(c)
	return c:IsSetCard(0xd3f) and c:IsAbleToGraveAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mysticfil,tp,LOCATION_DECK,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.mysticfil,tp,LOCATION_DECK,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LSTN("M"))>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xd3f,M_type,M_atk,M_def,M_level,RACE_SPELLCASTER,M_att) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LSTN("M"))<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xd3f,M_type,M_atk,M_def,M_level,RACE_SPELLCASTER,M_att) then
		c:AddMonsterAttribute(TYPE_RITUAL+TYPE_EFFECT)
		Duel.SpecialSummonStep(c,SUMMON_TYPE_RITUAL+1,tp,tp,true,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end

--효과 적용
function cm.con0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL+1
end

--함정 무효
function cm.distarget(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_TRAP)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LSTN("S") and re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end

--무효 + 바운스
function cm.con5(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL+1
		and ep~=tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev)
end
function cm.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function cm.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsLocation(LSTN("O")) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
	end
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsLocation(LSTN("O")) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoHand(eg,nil,REASON_EFFECT)
	end
end
