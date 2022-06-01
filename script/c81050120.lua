--필드 미애즈마
--카드군 번호: 0xca6
function c81050120.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c81050120.dscn)
	e2:SetTarget(c81050120.dstg)
	c:RegisterEffect(e2)
	
	--send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81050120,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c81050120.sgcn)
	e3:SetTarget(c81050120.sgtg)
	e3:SetOperation(c81050120.sgop)
	c:RegisterEffect(e3)
end


--disable
function c81050120.dscnfilter(c)
	return c:IsFaceup() and ( c:IsCode(81050000) )
end
function c81050120.dscn(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)<2
	   and Duel.IsExistingMatchingCard(c81050120.dscnfilter,tp,LOCATION_MZONE,0,1,nil)
   and not Duel.IsExistingMatchingCard(c81050120.dscnfilter,tp,0,LOCATION_MZONE,1,nil)
end

function c81050120.dstg(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
	   and c:IsFaceup()
end

--send to grave
function c81050120.sgcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end

function c81050120.sgtgfilter(c)
	return c:IsSetCard(0xca6) and c:IsAbleToGrave()
end
function c81050120.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81050120.sgtgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function c81050120.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81050120.sgtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
