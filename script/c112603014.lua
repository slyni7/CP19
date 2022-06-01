--Re(리)：프톨레마이오스
local m=112603014
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0xe9c)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:EnableReviveLimit()
	--counter
	kaos.recounter(c)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--Remove counter replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_RCOUNTER_REPLACE+0xe9c)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.rcon)
	e4:SetOperation(cm.rop)
	c:RegisterEffect(e4)
	--counter plus
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.countcost)
	e3:SetTarget(cm.counttg)
	e3:SetOperation(cm.countop)
	c:RegisterEffect(e3)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe9b))
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
end

--link summon
function cm.matfilter(c)
	return c:GetCounter(0xe9c)>0 and not c:IsLinkType(TYPE_LINK)
end

--special summon
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.filter(c,e,tp,zone)
	return c:IsSetCard(0xe9b) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
		return zone~=0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
	if zone~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,zone)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end

--Remove counter replace
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActivated() and bit.band(r,REASON_COST)~=0 and ep==e:GetOwnerPlayer() and e:GetHandler():GetCounter(0xe9c)>=ev
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0xe9c,ev,REASON_EFFECT)
end

--counter plus
function cm.cfilter(c,tp,g,zone)
	return g:IsContains(c) and (Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_TOFIELD,zone[tp])>0
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[1-tp])>0)
end
function cm.countcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local zone={}
	zone[0]=c:GetLinkedZone(0)
	zone[1]=c:GetLinkedZone(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,tp,lg,zone) end
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,tp,lg,zone)
	Duel.Release(g,REASON_COST)
end
function cm.countfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe9b) and c:IsCanAddCounter(0xe9c,2)
end
function cm.counttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and cm.countfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.countfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.countfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function cm.countop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0xe9c,2)
	end
end

--atkup
function cm.atkval(e,c)
	return e:GetHandler():GetCounter(0xe9c)*100
end