--[ RainbowFish ]
local m=99970609
local cm=_G["c"..m]
function cm.initial_effect(c)

	YuL.Activate(c)
	
	--공수 증가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRainbowFishCard))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--내성 부여
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetRange(LOCATION_FZONE)
	e0:SetTargetRange(LOCATION_ONFIELD,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsRainbowFish))
	e0:SetValue(cm.efilter)
	c:RegisterEffect(e0)
	
	--특수 소환
	local e1=MakeEff(c,"I","F")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)

	--파괴 대행
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(cm.desreptg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(cm.reptg)
	e5:SetValue(cm.repval)
	c:RegisterEffect(e5)
	
end

--내성 부여
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--특수 소환
function cm.cfil2(c)
	return c:IsAbleToRemoveAsCost() and c:IsRainbowFish()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.cfil2,tp,LSTN("G"),0,nil)
	mg:Merge(Duel.GetOverlayGroup(tp,1,1):Filter(cm.cfil2,nil))
	if chk==0 then return #mg>2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=mg:Select(tp,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsRainbowFishCard() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--파괴 대행
function cm.rmfilter(c)
	return c:IsRainbowFish() and c:IsAbleToRemove()
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
	return not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_GRAVE,0,2,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,2,2,c)
		Duel.Remove(g:GetFirst(),POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_THUNDER)
		and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp) and Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_GRAVE,0,2,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,2,2,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
