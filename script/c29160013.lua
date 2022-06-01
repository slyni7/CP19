--아스트로그래프 EDM
function c29160013.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--pendulum set/spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29160013,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,29160013)
	e1:SetTarget(c29160013.rptg)
	e1:SetOperation(c29160013.rpop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29160013,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c29160013.spcon)
	e2:SetTarget(c29160013.sptg)
	e2:SetOperation(c29160013.spop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29160013,5))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c29160013.hncost)
	e3:SetTarget(c29160013.hntg)
	e3:SetOperation(c29160013.hnop)
	c:RegisterEffect(e3)
	if not c29160013.global_check then
		c29160013.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c29160013.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c29160013.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
			tc:RegisterFlagEffect(29160013,RESET_EVENT+0x1f20000+RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsLocation(LOCATION_EXTRA) then
			tc:RegisterFlagEffect(29160013,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c29160013.rpfilter(c,e,tp)
	return c:IsSetCard(0x2c7) and c:GetLeftScale()<=4 and c:IsType(TYPE_PENDULUM) and (not c:IsForbidden()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c29160013.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29160013.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c29160013.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29160013,6))
		local g=Duel.SelectMatchingCard(tp,c29160013.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		local op=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			op=Duel.SelectOption(tp,aux.Stringid(29160013,1),aux.Stringid(29160013,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(29160013,1))
		end
		if op==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			Duel.RaiseSingleEvent(tc,EVENT_DESTROY,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
			Duel.RaiseEvent(g,EVENT_DESTROY,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
			Duel.RaiseSingleEvent(tc,EVENT_DESTROYED,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
			Duel.RaiseEvent(g,EVENT_DESTROYED,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c29160013.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:GetPreviousControler()==tp and c:IsSetCard(0x2c7)
end
function c29160013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29160013.spcfilter,1,nil,tp)
end
function c29160013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c29160013.thfilter1(c,tp,id)
	return c:IsType(TYPE_MONSTER) and c:GetFlagEffect(29160013)~=0
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c29160013.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c29160013.thfilter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c29160013.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c29160013.thfilter1,tp,0x70,0x70,nil,tp,Duel.GetTurnCount())
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29160013,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29160013,7))
			local cg=g:Select(tp,1,1,nil)
			Duel.HintSelection(cg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c29160013.thfilter2,tp,LOCATION_DECK,0,1,1,nil,cg:GetFirst():GetCode())
			Duel.SendtoHand(sg,nil,REASON_EFFECT+REASON_DESTROY)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c29160013.cfilter(c)
	return c:IsSetCard(0x2c7) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c29160013.fselect(c,tp,mg,sg,mc,...)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<5 then
		res=mg:IsExists(c29160013.fselect,1,sg,tp,mg,sg,mc)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		local g=Group.FromCards(mc)
		if sg:GetClassCount(Card.GetAttribute)==5 then
			res=true
		end
	end
	sg:RemoveCard(c)
	return res
end
function c29160013.hnfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function c29160013.hncost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c29160013.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local sg=Group.FromCards(c)
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and mg:IsExists(c29160013.fselect,1,sg,tp,mg,sg,c) end
	while sg:GetCount()<5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,c29160013.fselect,1,1,sg,tp,mg,sg,c)
		sg:Merge(g)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c29160013.hntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29160013.hnfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29160013.hnop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29160013.hnfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
