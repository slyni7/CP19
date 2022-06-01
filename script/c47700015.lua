--미미크루 시로쿠
function c47700015.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_BEASTWARRIOR),2,2)
	c:EnableReviveLimit()
	--gamsahamnida
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c47700015.ccon)
	e1:SetTarget(c47700015.sptg)
	e1:SetOperation(c47700015.spop)
	c:RegisterEffect(e1)
	
	--Sero-yeol activated
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e4:SetCountLimit(1,47700016)
	e4:SetCondition(c47700015.srcon)
	e4:SetTarget(c47700015.srtg)
	e4:SetOperation(c47700015.srop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c47700015.srcon2)
	c:RegisterEffect(e5)
end

function c47700015.ccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function c47700015.filters(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x229) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_CONTINUOUS)
end
function c47700015.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c47700015.filters(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c47700015.filters,tp,LOCATION_SZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c47700015.filters,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47700015.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end


function c47700015.srcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetColumnGroup():IsContains(re:GetHandler()) and re:GetHandler():IsSetCard(0x229)
end

function c47700015.ccfilter(c,tp)
	return c:IsSetCard(0x229)
end
function c47700015.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x229)
end
function c47700015.srcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c47700015.ccfilter,1,nil,tp) and c:GetColumnGroup():IsContains(re:GetHandler())
end


function c47700015.tfil2(c,e,tp,zone)
	return c:IsSetCard(0x229) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c47700015.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)&0x1f
	if chk==0 then
		return Duel.IsExistingMatchingCard(c47700015.tfil2,tp,LOCATION_DECK,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47700015.srop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local zone=c:GetLinkedZone(tp)&0x1f
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c47700015.tfil2,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end