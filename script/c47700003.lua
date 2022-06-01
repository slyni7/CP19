--미미크루 코우하쿠
function c47700003.initial_effect(c)
	--special summon or magic
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47700003,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,47700003)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c47700003.spcon1)
	e1:SetTarget(c47700003.sptar1)
	e1:SetOperation(c47700003.sp1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e1:SetDescription(aux.Stringid(47700003,0))
	e1:SetCondition(c47700003.spcon2)
	e1:SetTarget(c47700003.sptar2)
	e1:SetOperation(c47700003.sp2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47700003,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,47700003)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c47700003.setcon)
	e3:SetTarget(c47700003.settar)
	e3:SetOperation(c47700003.setop)
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
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e4:SetCountLimit(1,47700004)
	e4:SetCondition(c47700003.srcon)
--  e4:SetTarget(c47700003.srtg)
	e4:SetOperation(c47700003.srop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c47700003.srcon2)
	c:RegisterEffect(e5)

end
----naen da
function c47700003.cfilter(c)
	return c:GetSequence()<5
end
function c47700003.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47700003.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c47700003.sptar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c47700003.sp1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<1 then return
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c47700003.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47700003.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c47700003.sptar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c47700003.sp2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<1 or Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)<1 then return
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
	end
end

function c47700003.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE,tp)>0
end
function c47700003.settar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c47700003.setop(e,tp,eg,ep,ev,re,r,rp)
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

function c47700003.srcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetColumnGroup():IsContains(re:GetHandler()) and re:GetHandler():IsSetCard(0x229)
end

function c47700003.ccfilter(c,tp)
	return c:IsSetCard(0x229)
end
function c47700003.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x229) and c:IsSSetable(true)
end
function c47700003.srcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c47700003.ccfilter,1,nil,tp) and c:GetColumnGroup():IsContains(re:GetHandler())
end

function c47700003.srop(e,tp,eg,ep,ev,re,r,rp)
	p=e:GetHandler():GetOwner()
	local g=Duel.GetMatchingGroup(c47700003.filter,tp,LOCATION_DECK,0,nil)
	if tp~=p then
	g=Duel.GetMatchingGroup(c47700003.filter,tp,0,LOCATION_DECK,nil)
	end
	if g:GetCount()>0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SET)
			local sg=g:Select(p,1,1,nil)
			Duel.SSet(p,sg:GetFirst())
			Duel.ConfirmCards(1-p,sg)
	end
end

--box
--function c47700003.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
--  p=e:GetHandler():GetOwner()
--  if chk==0 then return Duel.IsExistingMatchingCard(c47700003.filter,p,LOCATION_DECK,0,1,nil) end
--  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,p,LOCATION_DECK)
--end