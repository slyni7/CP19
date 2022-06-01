--어노말리페이탈에러플레이어 >> 벡터
local m=112603034
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,5,99,cm.lcheck)
	--DATA : COMPLEX NUMBER
	kaos.fatalimit(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCost(kaos.fatcost)
	e1:SetCondition(cm.sscon)
	e1:SetTarget(kaos.fattg)
	e1:SetOperation(kaos.fatop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,5))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.thcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--fatal error!!
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCost(cm.fecost)
	e4:SetTarget(cm.fetg)
	e4:SetOperation(cm.feop)
	c:RegisterEffect(e4)
end

--link summon
function cm.lcheck(g)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount() and g:GetClassCount(Card.GetLinkCode)==g:GetCount() and g:IsExists(Card.IsLinkSetCard,1,nil,0x1e93)
end

--Special summon
function cm.filter0(c)
	return c:IsSetCard(0xe93) and c:IsType(TYPE_MONSTER) and not c:IsCode(m)
end
function cm.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter0,tp,LOCATION_GRAVE,0,1,nil)
end

--spsummon
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.filterp(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)&0x1f
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.filterp(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filterp,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filterp,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local zone=c:GetLinkedZone(tp)&0x1f
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tfil2,tp,LOCATION_REMOVED,0,1,3,nil,e,tp,zone)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
		Duel.SpecialSummonComplete()
	end
end

--search
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
	return c:IsSetCard(0xe93) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- fatal error!!
function cm.fefilter0(c)
	return (c:IsSetCard(0xe93) and c:IsType(TYPE_NORMAL) and c:IsAbleToGraveAsCost())
end
function cm.fefilter2(c,g)
	return g:IsContains(c)
end
function cm.fecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lg=e:GetHandler():GetLinkedGroup()
		local sel=0
		if Duel.IsExistingMatchingCard(cm.fefilter0,tp,LOCATION_DECK,0,1,nil) then sel=sel+1 end
		if Duel.CheckReleaseGroup(tp,cm.fefilter2,1,nil,lg) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		sel=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(m,1))
	else
		Duel.SelectOption(tp,aux.Stringid(m,2))
	end
	e:SetLabel(sel)	
	if sel==1 then
		local x=Duel.SelectMatchingCard(tp,cm.fefilter0,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(x,REASON_COST)	
	else
		local lg=e:GetHandler():GetLinkedGroup()
		local h=Duel.SelectReleaseGroup(tp,cm.fefilter2,1,1,nil,lg)
		Duel.Release(h,REASON_COST)
	end
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