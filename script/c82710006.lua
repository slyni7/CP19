--아르카나 포스 XI-저스티스
function c82710006.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_COIN)
	e1:SetTarget(c82710006.tar1)	
	e1:SetOperation(c82710006.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCost(c82710006.cost4)
	e4:SetTarget(c82710006.tar4)
	e4:SetOperation(c82710006.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCountLimit(1,82710006)
	e5:SetCost(c82710006.cost5)
	e5:SetTarget(c82710006.tar5)
	e5:SetOperation(c82710006.op5)
	c:RegisterEffect(e5)
end
c82710006.toss_coin=true
function c82710006.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c82710006.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else
		res=Duel.TossCoin(tp,1)
	end
	c82710006.arcanareg(c,res)
end
function c82710006.arcanareg(c,coin)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCondition(c82710006.acon1)
	e1:SetTarget(c82710006.atar1)
	e1:SetTarget(c82710006.aop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetCondition(c82710006.acon2)
	e2:SetTarget(c82710006.atar2)
	e2:SetOperation(c82710006.aop2)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c82710006.anfil1(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c82710006.acon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(36690018)==1 and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)<=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
end
function c82710006.atar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c82710006.aop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c82710006.acon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffectLabel(36690018)~=0 or ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then
		return false
	end
	return re:IsActiveType(TYPE_MONSTER)
end
function c82710006.atar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c82710006.aop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c82710006.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c82710006.tfil4(c)
	return c:IsCode(73206827) and c:IsAbleToHand()
end
function c82710006.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c82710006.tfil4,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_HAND)
end
function c82710006.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82710006.tfil4,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c82710006.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then
		return true
	end
end
function c82710006.cfil5(c)
	return c:IsSetCard(0x5) and c:IsAbleToRemoveAsCost()
end
function c82710006.tfil51(c,g,sg,e,tp)
	sg:AddCard(c)
	local res=(sg:GetCount()<4 and Duel.IsExistingMatchingCard(c82710006.tfil52,tp,LOCATION_DECK,0,1,nil,sg,e,tp))
		or (sg:GetCount()<3 and g:IsExists(c82710006.tfil51,1,sg,g,sg,e,tp))
	sg:RemoveCard(c)
	return res
end
function c82710006.tfil52(c,g,e,tp)
	local sum=g:GetSum(aux.IsArcanaNumber)
	return c:IsSetCard(0x5) and aux.IsArcanaNumber(c)<=sum and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsCode(82710006)
end
function c82710006.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c82710006.cfil5,tp,LOCATION_GRAVE,0,1,nil)
	local sg=Group.FromCards(c)
	if chk==0 then
		if e:GetLabel()~=100 then
			return false
		end
		return c:IsAbleToRemoveAsCost() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and (Duel.IsExistingMatchingCard(c82710006.tfil52,tp,LOCATION_DECK,0,1,nil,sg,e,tp)
				or g:IsExists(c82710006.tfil51,1,sg,g,sg,e,tp))
	end
	while #sg<3 do
		local cg=g:Filter(c82710006.tfil51,sg,g,sg,e,tp)
		if #cg<1 then
			break
		end
		local finish=Duel.IsExistingMatchingCard(c82710006.tfil52,tp,LOCATION_DECK,0,1,nil,sg,e,tp)
		if finish and not Duel.SelectYesNo(tp,aux.Stringid(82710006,0)) then
			break
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=cg:Select(tp,1,1,nil)
			sg:Merge(tg)
		end
	end
	local sum=sg:GetSum(aux.IsArcanaNumber)
	e:SetLabel(sum)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c82710006.ofil5(c,sum,e,tp)
	return c:IsSetCard(0x5) and aux.IsArcanaNumber(c)<=sum and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsCode(82710006)
end
function c82710006.op5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	local sum=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82710006.ofil5,tp,LOCATION_DECK,0,1,1,nil,sum,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end