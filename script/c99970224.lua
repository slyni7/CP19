--Mystic Orchestra O 「Opening」
local m=99970224
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Mystic Orchestra
	local e1=YuL.ActST(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LSTN("E"))
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--세트
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(spinel.delay)
	WriteEff(e2,0,"N")
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--회수
	local e3=MakeEff(c,"Qo","M")
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(spinel.relcost)
	WriteEff(e3,0,"N")
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
--[[
	--마법 & 함정 존 발동
	local e0=MakeEff(c,"F","E")
	e0:SetCode(EFFECT_ACTIVATE_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,1)
	e0:SetCost(cm.cost0)
	e0:SetTarget(cm.tar0)
	e0:SetOperation(cm.op0)
	c:RegisterEffect(e0)
	]]
end

--Info
cm.mystic_orchestra_num=0
M_level=0
M_att=ATTRIBUTE_DEVINE
M_atk=0
M_def=0
M_type=TYPE_MONSTER+TYPE_EFFECT+TYPE_RITUAL+TYPE_FUSION+TYPE_TUNER

--Mystic Orchestra
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0xd3f) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0xd3f)
	Duel.Release(g,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xd3f,M_type,M_atk,M_def,M_level,RACE_SPELLCASTER,M_att) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LSTN("M"))<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xd3f,M_type,M_atk,M_def,M_level,RACE_SPELLCASTER,M_att) then
		c:AddMonsterAttribute(TYPE_RITUAL+TYPE_EFFECT+TYPE_FUSION+TYPE_TUNER)
		c:SetStatus(STATUS_NO_LEVEL,true)
		Duel.SpecialSummonStep(c,SUMMON_TYPE_RITUAL+1,tp,tp,true,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end

--효과 적용
function cm.con0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL+1
end

--세트
function cm.filter(c)
	return c:IsSetCard(0xd3f) and c:IsType(YuL.ST) and c:IsSSetable()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g:GetFirst())
	end
end

--회수
function cm.thfilter(c)
	return c:IsSetCard(0xd3f) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--마법 & 함정 존 발동
function cm.cost0(e,te,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.tar0(e,te,tp)
	local c=e:GetHandler()
	local tc=te:GetHandler()
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and c==tc
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
end
