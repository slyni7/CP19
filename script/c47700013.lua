--미미크루 세이하쿠
function c47700013.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEASTWARRIOR),4,2)
	c:EnableReviveLimit()
	--gamsahamnida
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c47700013.ccon)
	e3:SetTarget(c47700013.ctg)
	e3:SetOperation(c47700013.cop)
	c:RegisterEffect(e3)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,47700014)
	e4:SetCost(c47700013.srcost)
	e4:SetCondition(c47700013.srcon)
	e4:SetTarget(c47700013.srtg)
	e4:SetOperation(c47700013.srop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c47700013.srcon2)
	c:RegisterEffect(e5)
end

function c47700013.ccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function c47700013.tfil1(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and c:IsSetCard(0x229)
end
function c47700013.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c47700013.tfil1,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c47700013.tfil1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c47700013.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c47700013.tfil1,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.GetControl(g,tp)
	end
end


function c47700013.srcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetColumnGroup():IsContains(re:GetHandler()) and re:GetHandler():IsSetCard(0x229)
end

function c47700013.ccfilter(c,tp)
	return c:IsSetCard(0x229)
end
function c47700013.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x229) and c:IsFaceup()
end
function c47700013.srcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c47700013.ccfilter,1,nil,tp) and c:GetColumnGroup():IsContains(re:GetHandler())
end


function c47700013.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c47700013.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47700013.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c47700013.srop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c47700013.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end