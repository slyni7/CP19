--Star Absorber
function c99970076.initial_effect(c)
	
	--레벨 0
	c:SetStatus(STATUS_NO_LEVEL,true)

	--융합 소환
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xd36),c99970076.cfilter,2,true,true)

		--융합 소재 제약
		local ef=Effect.CreateEffect(c)
		ef:SetType(EFFECT_TYPE_SINGLE)
		ef:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ef:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		ef:SetValue(1)
		c:RegisterEffect(ef)

		--특수 소환 제한
		local ef1=Effect.CreateEffect(c)
		ef1:SetType(EFFECT_TYPE_SINGLE)
		ef1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ef1:SetCode(EFFECT_SPSUMMON_CONDITION)
		ef1:SetValue(c99970076.splimit)
		c:RegisterEffect(ef1)
		
		--융합 소재
		local ef2=Effect.CreateEffect(c)
		ef2:SetType(EFFECT_TYPE_FIELD)
		ef2:SetCode(EFFECT_SPSUMMON_PROC)
		ef2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		ef2:SetRange(LOCATION_EXTRA)
		ef2:SetCondition(c99970076.sprcon)
		ef2:SetOperation(c99970076.sprop)
		c:RegisterEffect(ef2)

	--스타 앱소버 공격력
	local es=Effect.CreateEffect(c)
	es:SetType(EFFECT_TYPE_SINGLE)
	es:SetCode(EFFECT_UPDATE_ATTACK)
	es:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	es:SetRange(LOCATION_MZONE)
	es:SetValue(c99970076.starabsorber)
	c:RegisterEffect(es)

	--카운터
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970076,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(c99970076.operation)
	c:RegisterEffect(e1)

	--무효
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99970076,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c99970076.discon)
	e2:SetCost(c99970076.discost)
	e2:SetTarget(c99970076.distg)
	e2:SetOperation(c99970076.disop)
	c:RegisterEffect(e2)
	
end

--융합 소환
function c99970076.cfilter(c,tp)
	return (c:IsFusionSetCard(0xd36) or ((c:GetLevel()-c:GetOriginalLevel()>=9 or c:GetOriginalLevel()-c:GetLevel()>=9) or (c:GetRank()-c:GetOriginalRank()>=9 or c:GetOriginalRank()-c:GetRank()>=9)))
		and c:IsType(TYPE_MONSTER)
		and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function c99970076.fcheck(c,sg)
	return c:IsFusionSetCard(0xd36) and sg:FilterCount(c99970076.fcheck2,c)+1==sg:GetCount()
end
function c99970076.fcheck2(c)
	return ((c:GetLevel()-c:GetOriginalLevel()>=9 or c:GetOriginalLevel()-c:GetLevel()>=9)
		or (c:GetRank()-c:GetOriginalRank()>=9 or c:GetOriginalRank()-c:GetRank()>=9))
		and c:IsType(TYPE_MONSTER)
end
function c99970076.fgoal(c,tp,sg)
	return sg:GetCount()>2 and Duel.GetLocationCountFromEx(tp,tp,sg)>0 and sg:IsExists(c99970076.fcheck,1,nil,sg)
end
function c99970076.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c99970076.fgoal(c,tp,sg) or mg:IsExists(c99970076.fselect,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c99970076.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c99970076.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c99970076.fselect,1,nil,tp,mg,sg)
end
function c99970076.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c99970076.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c99970076.fselect,sg,tp,mg,sg)
		if cg:GetCount()==0
			or (c99970076.fgoal(c,tp,sg) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=cg:Select(tp,1,1,nil)
		sg:Merge(g)
	end
	Duel.SendtoGrave(sg,REASON_COST)
end

--스타 앱소버 공격력
function c99970076.starabsorber(e,c)
	return Duel.GetCounter(0,1,1,0x1051)*100
end

--카운터
function c99970076.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1051,1,REASON_EFFECT)
		tc=g:GetNext()
	end
end

--무효
function c99970076.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c99970076.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1051,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1051,3,REASON_COST)
end
function c99970076.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c99970076.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

