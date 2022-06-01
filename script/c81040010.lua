--메가 플레어

function c81040010.initial_effect(c)
	
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c81040010.dscn)
	e2:SetTarget(c81040010.dstg)
	e2:SetOperation(c81040010.dsop)
	c:RegisterEffect(e2)
	
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c81040010.ssco)
	e3:SetTarget(c81040010.sstg)
	e3:SetOperation(c81040010.ssop)
	c:RegisterEffect(e3)
	
end

--destroy
function c81040010.dscnfilter(c)
	return c:IsFaceup() and c:IsCode(81040000)
end
function c81040010.dscn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81040010.dscnfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

function c81040010.dstgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c81040010.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81040010.dstgfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	local sg=Duel.GetMatchingGroup(c81040010.dstgfilter,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,sg:GetCount()*400)
end

function c81040010.dsop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c81040010.dstgfilter,tp,0,LOCATION_MZONE,e:GetHandler())
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	if ct then
			Duel.Damage(1-tp,ct*400,REASON_EFFECT)
			Duel.Damage(tp,ct*400,REASON_EFFECT)
	end
end

--special summon
function c81040010.ssco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c81040010.sstgfilter(c,e,tp)
	return c:IsCode(81040000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81040010.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c81040010.sstgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingTarget(c81040010.sstgfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81040010.sstgfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c81040010.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
