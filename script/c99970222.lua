--Mystic Orchestra XII 「Lake」
local m=99970222
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Mystic Orchestra
	local e1=YuL.ActST(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	
	--효과 대상 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	WriteEff(e2,0,"N")
	c:RegisterEffect(e2)
	
	--무효 + 제외
	local e3=MakeEff(c,"FC","M")
	e3:SetCode(EVENT_CHAIN_ACTIVATING)
	WriteEff(e3,0,"N")
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
	
	--무효 + 바운스
	local e4=MakeEff(c,"Qo","M")
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	WriteEff(e4,0,"N")
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)

end

--Info
cm.mystic_orchestra_num=12
M_level=12
M_att=ATTRIBUTE_WATER
M_atk=3700
M_def=1100
M_type=TYPE_MONSTER+TYPE_EFFECT+TYPE_RITUAL

--Mystic Orchestra
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LSTN("O"),0)<=5
end
function cm.mysticfil(c)
	return c:IsSetCard(0xd3f) and c:IsAbleToDeckAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mysticfil,tp,LOCATION_GRAVE,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.mysticfil,tp,LOCATION_GRAVE,0,5,5,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
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

--무효 + 제외
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ph=Duel.GetCurrentPhase()
	if ph<PHASE_BATTLE_START or ph>PHASE_BATTLE then return end
	if rp~=tp and Duel.NegateActivation(ev)~=0 and rc:IsRelateToEffect(re) then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end

--무효 + 바운스
function cm.filter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsAbleToHand()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LSTN("M")) and chkc:IsControler(1-tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LSTN("M"),1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,0,LSTN("M"),1,1,nil)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled()
		and tc:IsControler(1-tp) and tc:IsAbleToHand() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
