--[The Shard of Dream]
local m=99970543
local cm=_G["c"..m]
function cm.initial_effect(c)

	--스퀘어
	aux.AddSquareProcedure(c)

	--●바운스
	local e1=MakeEff(c,"I","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCL(1,YuL.S)
	WriteEff(e1,1,"TO")
	e1:SetCondition(spinel.stypecon(SUMMON_TYPE_SQUARE,cm.con1))
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(spinel.stypecon(SUMMON_TYPE_SQUARE,cm.con2))
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_MATERIAL)
	WriteEff(e0,0,"NO")
	c:RegisterEffect(e0)
	
	--특수 소환
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(spinel.delay)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	
end

--스퀘어
cm.square_mana={ATTRIBUTE_WATER,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE

--●바운스
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsLevelAbove(4)
end
function cm.thfil(c)
	return c:IsAbleToHand() and c:IsFaceup()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.thfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLevelAbove(4)
end
function cm.con0(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO or r==REASON_SQUARE
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=MakeEff(rc,"I","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCL(1,YuL.S)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	rc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.con2)
	rc:RegisterEffect(e2,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_TYPE)
		e0:SetValue(TYPE_EFFECT)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		rc:RegisterEffect(e0,true)
	end
end

--특수 소환
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xd31) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
