--Mystic Orchestra V 「White Wings」
local m=99970215
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Mystic Orchestra
	local e1=YuL.ActST(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--전투 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	WriteEff(e2,0,"N")
	c:RegisterEffect(e2)
	
	--직접 공격
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	WriteEff(e3,0,"N")
	c:RegisterEffect(e3)
	
	--소환 무효 + 바운스
	local e4=MakeEff(c,"Qo","M")
	e4:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOHAND)
	e4:SetCode(EVENT_SUMMON)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e6)
	
end

--Info
cm.mystic_orchestra_num=5
M_level=5
M_att=ATTRIBUTE_WIND
M_atk=1500
M_def=2200
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

--소환 무효 + 바운스
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL+1 and tp~=ep and Duel.GetCurrentChain()==0
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,eg:GetCount(),0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoHand(eg,nil,REASON_EFFECT)
end
