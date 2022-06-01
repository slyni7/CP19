--[LittleWitch]
local m=99970590
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	
	--세트턴 발동
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_SINGLE)
	eb:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	eb:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	eb:SetCondition(cm.actcon)
	c:RegisterEffect(eb)
	
	--샐비지
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(aux.exccon)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

end

--특수 소환
function cm.sfil(c,e,tp)
	return c:IsSetCard(0xe16) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.sfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.sfil),tp,LOCATION_HAND,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or #g<=0 then return end
	local ct=math.min(ft,3)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end

--세트턴 발동
function cm.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0xe16)
end
function cm.actcon(e)
	return not Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

--샐비지
function cm.filter(c,tid)
	return c:GetTurnID()==tid and c:IsSetCard(0xe16) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc,tid) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,tid)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
