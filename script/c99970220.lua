--Mystic Orchestra X 「Blink」
local m=99970220
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Mystic Orchestra
	
	local e1=YuL.ActST(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	
	--무효 내성 부여
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetValue(cm.effectfilter)
	WriteEff(e2,0,"N")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetValue(cm.effectfilter)
	WriteEff(e3,0,"N")
	c:RegisterEffect(e3)
	
	--파괴 회피
	local e4=MakeEff(c,"FC","M")
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetValue(cm.repval)
	WriteEff(e4,0,"N")
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	
	--특소 체크
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clearop)
		Duel.RegisterEffect(ge2,0)
	end
	
end

--Info
cm.mystic_orchestra_num=10
M_level=10
M_att=ATTRIBUTE_LIGHT
M_atk=3100
M_def=1000
M_type=TYPE_MONSTER+TYPE_EFFECT+TYPE_RITUAL

--Mystic Orchestra
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function cm.mysticfil(c)
	return c:IsSetCard(0xd3f) and c:IsAbleToGraveAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mysticfil,tp,LOCATION_DECK,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.mysticfil,tp,LOCATION_DECK,0,3,3,nil)
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

--무효 내성 부여
function cm.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x103) and bit.band(loc,LOCATION_ONFIELD)~=0
end

--파괴 회피
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd3f) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.desrepfilter(c)
	return c:GetType()&TYPE_RITUAL>0 and c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(cm.repfilter,1,nil,tp) 
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.desrepfilter),tp,LSTN("G"),0,2,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.desrepfilter),tp,LSTN("G"),0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_REPLACE)
end
