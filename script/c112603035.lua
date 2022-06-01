--어노말리페이탈에러플레이어 >> 리미트
local m=112603035
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--P Effect
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA+LOCATION_PZONE)
	e1:SetCost(kaos.fatcost)
	e1:SetCondition(cm.sscon)
	e1:SetTarget(kaos.fattg)
	e1:SetOperation(kaos.fatop)
	c:RegisterEffect(e1)
	--fatal error!!
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCost(cm.fecost)
	e4:SetTarget(cm.fetg)
	e4:SetOperation(cm.feop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCost(cm.f2cost)
	c:RegisterEffect(e5)
	--M Effect
	--DATA : COMPLEX NUMBER
	kaos.fatalimit(c)
	--create
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(cm.crcost)
	e2:SetOperation(cm.crop)
	c:RegisterEffect(e2)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.ssscon)
	e2:SetTarget(cm.sstg)
	e2:SetOperation(cm.ssop)
	c:RegisterEffect(e2)
end

--P Effect
--Special summon
function cm.filter0(c)
	return c:IsSetCard(0xe93)
end
function cm.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter0,tp,LOCATION_DECK,0,1,nil)
end

-- fatal error!!
function cm.costfilter(c,tp)
	return c:IsType(TYPE_PENDULUM)
end
function cm.f2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,cm.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function cm.fefilter0(c)
	return (c:IsSetCard(0xe93) and c:IsType(TYPE_NORMAL)) or (c:IsType(TYPE_PENDULUM)) and c:IsAbleToGraveAsCost()
end
function cm.fecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fefilter0,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.fefilter0,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function cm.fefilter(c,e,tp)
	return c:IsSetCard(0x1e93) and c:IsType(TYPE_MONSTER) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp)>0
				or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function cm.fetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fefilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE)
end
function cm.feop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.fefilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end

--M Effect
--create
function cm.crfilter(c,tp)
	return c:IsRace(RACE_CYBERSE)
end
function cm.crcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.crfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,cm.crfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function cm.crop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,112603031)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112603032)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112603033)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112603034)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,m)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112603036)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
end

--Summon Success
function cm.ssscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function cm.ssfil(c)
	return not c:IsType(TYPE_FIELD)
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ssfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(cm.ssfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.ssfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SendtoDeck(sg,nil,-2,REASON_EFFECT)
end