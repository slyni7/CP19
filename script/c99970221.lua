--Mystic Orchestra XI 「Wisdom」
local m=99970221
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Mystic Orchestra
	local e1=YuL.ActST(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	
	--속성 변경 + 바운스
	local e2=MakeEff(c,"Qo","M")
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	WriteEff(e2,0,"N")
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--효과 발동 제한
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetValue(cm.aclimit)
	WriteEff(e3,0,"N")
	c:RegisterEffect(e3)
	
	--공격력 감소
	local e4=MakeEff(c,"I","G")
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(aux.exccon)
	e4:SetCost(aux.bfgcost)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	
end

--Info
cm.mystic_orchestra_num=11
M_level=11
M_att=ATTRIBUTE_EARTH
M_atk=600
M_def=3500
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

--속성 변경 + 바운스
function cm.thfilter(c,Att)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsAttribute(Att)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local aat=Duel.AnnounceAttribute(tp,1,0xff-e:GetHandler():GetAttribute())
	e:SetLabel(aat)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,0,LSTN("M"),nil,aat)
	if #g>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local ATT=e:GetLabel()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(cm.thfilter,tp,0,LSTN("M"),nil,ATT)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end

--효과 발동 제한
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsAttribute(e:GetHandler():GetAttribute()) and not re:GetHandler():IsImmuneToEffect(e)
		and e:GetHandler()~=re:GetHandler()
end

--공격력 감소
function cm.atkfil(c)
	return c:IsSetCard(0xd3f) and not c:IsCode(99970224,99970262)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LSTN("G")) and chkc:IsControler(tp) and cm.atkfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.atkfil,tp,LSTN("G"),0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LSTN("M"),1,nil) end
	local g=Duel.SelectTarget(tp,cm.atkfil,tp,LSTN("G"),0,1,1,e:GetHandler())
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local N=_G["c"..tc:GetCode()]
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LSTN("M"),nil)
	local sg=g:GetFirst()
	local ct=N.mystic_orchestra_num
	while sg do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*-100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sg:RegisterEffect(e1)
		sg=g:GetNext()
	end
end
