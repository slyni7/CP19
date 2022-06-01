--Mystic Orchestra I 「Lovers」
local m=99970211
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Mystic Orchestra
	local e1=YuL.ActST(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--드로우
	local e2=MakeEff(c,"I","M")
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCountLimit(1)
	WriteEff(e2,0,"N")
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	
	--공격 / 효과 대상 내성 부여
	local e3=MakeEff(c,"F","M")
	e3:SetTargetRange(0,LSTN("M"))
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetValue(cm.atlimit)
	WriteEff(e3,0,"N")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","M")
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LSTN("M"),0)
	e4:SetTarget(cm.tglimit)
	e4:SetValue(aux.tgoval)
	WriteEff(e4,0,"N")
	c:RegisterEffect(e4)
	
	--샐비지
	local e5=MakeEff(c,"STo")
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+spinel.delay)
	e5:SetCode(EVENT_DESTROYED)
	WriteEff(e5,5,"NTO")
	c:RegisterEffect(e5)

end

--Info
cm.mystic_orchestra_num=1
M_level=1
M_att=ATTRIBUTE_WATER
M_atk=1000
M_def=600
M_type=TYPE_MONSTER+TYPE_EFFECT+TYPE_RITUAL

--Mystic Orchestra
function cm.mysticfil(c)
	return c:IsSetCard(0xd3f) and c:IsAbleToGraveAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mysticfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.mysticfil,tp,LOCATION_DECK,0,1,1,nil)
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

--드로우
function cm.costfilter(c)
	return c:IsAbleToRemoveAsCost() and c:GetType()&TYPE_RITUAL>0 and c:IsType(TYPE_SPELL)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LSTN("G"),0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LSTN("G"),0,2,3,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	e:SetLabel(#cg-1)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--공격 / 효과 대상 내성 부여
function cm.atlimit(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0xd3f)
end
function cm.tglimit(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0xd3f)
end

--샐비지
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function cm.filter(c)
	return c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToHand()
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LSTN("G")) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LSTN("G"),0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LSTN("G"),0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
