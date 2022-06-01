--지저 폭탄

function c81040100.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81040100+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81040100.ssco)
	e1:SetTarget(c81040100.sstg)
	e1:SetOperation(c81040100.ssop)
	c:RegisterEffect(e1)
	
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)	
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81040101+EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c81040100.dmco)
	e2:SetTarget(c81040100.dmtg)
	e2:SetOperation(c81040100.dmop)
	c:RegisterEffect(e2)
	
end

--Activate
function c81040100.sscofilter(c,e,tp)
	return c:IsSetCard(0xca4) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
	and Duel.IsExistingMatchingCard(c81040100.sstgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c81040100.ssco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81040100.sscofilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c81040100.sscofilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.Destroy(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end

function c81040100.sstgfilter(c,e,tp,dc,code)
	return c:IsSetCard(0xca4) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and not c:IsCode(dc:GetCode())
end
function c81040100.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end

function c81040100.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.SelectMatchingCard(tp,c81040100.sstgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabelObject())
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local lv=g:GetSum(Card.GetLevel)
		local rk=g:GetSum(Card.GetRank)
		local clv=0+lv+rk	
		if clv<0 then clv=0 end
		local val=Duel.Damage(tp,clv*100,REASON_EFFECT)
		if val>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,val,REASON_EFFECT)
		end
	end
end

--damage
function c81040100.dmcofilter(c)
	return c:IsSetCard(0xca4) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c81040100.dmco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c81040100.dmcofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81040100.dmcofilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c81040100.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,800)
end

function c81040100.dmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,800,REASON_EFFECT)
	Duel.Damage(tp,800,REASON_EFFECT)
end

	