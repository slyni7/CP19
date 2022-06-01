--Orcatia 
local m=99970350
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--패 발동
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)

	--공수 증가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe10))
	e3:SetValue(200)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	
	--LP 변경
	local e5=MakeEff(c,"Qo","G")
	e5:SetCode(EVENT_ATTACK_ANOUNCE)
	e5:SetCost(aux.bfgcost)
	WriteEff(e5,5,"NO")
	c:RegisterEffect(e5)
	
end

--특수 소환
function cm.spfilter1(c,e,tp)
	local att=c:GetOriginalAttribute()
	return att~=0 and c:IsSetCard(0xe10) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,att)
end
function cm.spfilter2(c,e,tp,att)
	return not c:IsAttribute(att) and c:IsType(TYPE_UNION) and c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LSTN("MG")) and chkc:IsControler(tp) and cm.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter1,tp,LSTN("MG"),0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.spfilter1,tp,LSTN("MG"),0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetOriginalAttribute())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--패 발동
function cm.hdfil(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.hdfil,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end

--LP 변경
function cm.cfil(c)
	return c:IsSetCard(0xe10) and c:IsType(TYPE_UNION)
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfil,tp,LOCATION_GRAVE,0,5,nil) and Duel.GetLP(tp)<4000
		and Duel.GetTurnPlayer()~=tp
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,4000)
end
