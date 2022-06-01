--미미크루 모모
function c47700009.initial_effect(c)
	--special summon or magic
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47700009,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,47700009)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c47700009.spcon1)
	e1:SetTarget(c47700009.sptar1)
	e1:SetOperation(c47700009.sp1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e1:SetDescription(aux.Stringid(47700009,0))
	e1:SetCondition(c47700009.spcon2)
	e1:SetTarget(c47700009.sptar2)
	e1:SetOperation(c47700009.sp2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47700009,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,47700009)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c47700009.setcon)
	e3:SetTarget(c47700009.settar)
	e3:SetOperation(c47700009.setop)
	c:RegisterEffect(e3)
	
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
	e4:SetCountLimit(1,47700010)
	e4:SetCondition(c47700009.srcon)
--  e4:SetTarget(c47700009.srtg)
	e4:SetOperation(c47700009.srop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c47700009.srcon2)
	c:RegisterEffect(e5)
end
----naen da
function c47700009.cfilter(c)
	return c:GetSequence()<5
end
function c47700009.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47700009.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c47700009.sptar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c47700009.sp1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<1 then return
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c47700009.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47700009.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c47700009.sptar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c47700009.sp2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<1 or Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)<1 then return
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
	end
end

function c47700009.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE,tp)>0
end
function c47700009.settar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c47700009.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end

--sero-yeol

function c47700009.srcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetColumnGroup():IsContains(re:GetHandler()) and re:GetHandler():IsSetCard(0x229)
end

function c47700009.ccfilter(c,tp)
	return c:IsSetCard(0x229)
end
function c47700009.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x229)
end
function c47700009.srcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c47700009.ccfilter,1,nil,tp) and c:GetColumnGroup():IsContains(re:GetHandler())
end

function c47700009.srop(e,tp,eg,ep,ev,re,r,rp)
	p=e:GetHandler():GetOwner()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINT_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c47700009.filter,tp,LOCATION_DECK,0,1,1,nil)
	if p~=tp then g=Duel.SelectMatchingCard(tp,c47700009.filter,tp,0,LOCATION_DECK,1,1,nil) end
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,p,p,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end

--box
function c47700009.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	p=e:GetHandler():GetOwner()
	if chk==0 then
	if p==tp then return Duel.IsExistingMatchingCard(c47700009.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	else return Duel.IsExistingMatchingCard(c47700009.filter,tp,0,LOCATION_DECK,1,nil)
		and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
end