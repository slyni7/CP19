--Mystic Orchestra XIII 「Occult」
local m=99970223
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Mystic Orchestra
	local e1=YuL.ActST(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LSTN("E"))
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	
	--공수 증가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	WriteEff(e2,0,"N")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
	--서치 / 샐비지
	local e4=MakeEff(c,"Qo","M")
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	WriteEff(e4,0,"N")
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	
	--무효
	local e5=MakeEff(c,"Qo","M")
	e5:SetCategory(CATEGORY_NEGATE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	WriteEff(e5,5,"NCTO")
	c:RegisterEffect(e5)
	
	--마법 & 함정 존 발동
	local e0=MakeEff(c,"F","E")
	e0:SetCode(EFFECT_ACTIVATE_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,1)
	e0:SetCost(cm.cost0)
	e0:SetTarget(cm.tar0)
	e0:SetOperation(cm.op0)
	c:RegisterEffect(e0)
	
end

--Info
cm.mystic_orchestra_num=13
M_level=13
M_att=ATTRIBUTE_DEVINE
M_atk=-2
M_def=-2
M_type=TYPE_MONSTER+TYPE_EFFECT+TYPE_RITUAL+TYPE_SYNCHRO

--Mystic Orchestra
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function cm.mysticfil(c,tp)
	return c:IsSetCard(0xd3f) and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function cm.mysticfun(g,tp,c)
	return g:CheckWithSumGreater(Card.GetRitualLevel,13,c) and Duel.GetMZoneCount(tp,g,tp)>0
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.mysticfil,tp,LSTN("M"),0,nil)
	if chk==0 then return g:CheckSubGroup(cm.mysticfun,1,#g,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,cm.mysticfun,false,1,#g,tp,c)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xd3f,M_type,M_atk,M_def,M_level,RACE_SPELLCASTER,M_att) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LSTN("M"))<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xd3f,M_type,M_atk,M_def,M_level,RACE_SPELLCASTER,M_att) then
		c:AddMonsterAttribute(TYPE_RITUAL+TYPE_EFFECT+TYPE_SYNCHRO)
		Duel.SpecialSummonStep(c,SUMMON_TYPE_RITUAL+1,tp,tp,true,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end

--효과 적용
function cm.con0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL+1
end

--공수 증가
function cm.atkfilter(c)
	return c:IsSetCard(0xd3f)
end
function cm.atkval(e,c)
	local g=Duel.GetMatchingGroup(cm.atkfilter,c:GetControler(),LSTN("G"),0,nil)
	return g:GetSum(function(c) return c.mystic_orchestra_num end)*100
end

--서치 / 샐비지
function cm.tgfilter(c)
	local Mus=_G["c"..c:GetCode()]
	return c:IsFaceup() and c:IsSetCard(0xd3f) and not c:IsCode(99970224,99970262) and Mus
		and Duel.IsExistingMatchingCard(cm.thfilter,c:GetControler(),LSTN("GD"),0,1,nil,Mus.mystic_orchestra_num)
end
function cm.thfilter(c,no)
	return c:IsAbleToHand() and c:IsSetCard(0xd3f) and not c:IsCode(99970262) and c.mystic_orchestra_num<no
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LSTN("GF")) and cm.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LSTN("GF"),0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LSTN("GF"),0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LSTN("GD"))
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local Mus=_G["c"..tc:GetCode()]
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or not Mus then return end
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LSTN("GD"),0,1,1,nil,Mus.mystic_orchestra_num)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end

--무효
function cm.negfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd3f) and c:IsControler(tp)
end
function cm.costfilter(c)
    return c:IsSetCard(0xd3f) and c:IsAbleToRemoveAsCost()
end
function cm.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(cm.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev) and ep~=tp
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
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
