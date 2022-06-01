--에퀴녹스 스트라이크
function c95480114.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,95480114+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c95480114.target)
	e1:SetOperation(c95480114.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c95480114.thcon)
	e2:SetTarget(c95480114.thtg)
	e2:SetOperation(c95480114.thop)
	c:RegisterEffect(e2)
	if not c95480114.global_check then
		c95480114.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(c95480114.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c95480114.mtfilter1(c)
	return c:IsSetCard(0xd5f) and c:IsType(TYPE_MONSTER)
end
function c95480114.mtfilter2(c)
	return c:IsFusionSetCard(0xd5f) and c:IsFusionType(TYPE_MONSTER)
end
function c95480114.mtfilter3(c)
	return c:IsSetCard(0xd5f) and c:IsSynchroType(TYPE_MONSTER)
end
function c95480114.mtfilter4(c)
	return c:IsSetCard(0xd5f) and c:IsXyzType(TYPE_MONSTER)
end
function c95480114.mtfilter5(c)
	return c:IsSetCard(0xd5f) and c:IsLinkType(TYPE_MONSTER)
end
function c95480114.valcheck(e,c)
	local g=c:GetMaterial()
	if c:IsType(TYPE_RITUAL) and g:IsExists(c95480114.mtfilter1,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_FUSION) and g:IsExists(c95480114.mtfilter2,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_SYNCHRO) and g:IsExists(c95480114.mtfilter3,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_XYZ) and g:IsExists(c95480114.mtfilter4,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	elseif c:IsType(TYPE_LINK) and g:IsExists(c95480114.mtfilter5,1,nil) then
		c:RegisterFlagEffect(95480000,RESET_EVENT+0x4fe0000,0,1)
	end
end

function c95480114.filter(c)
	return c:IsFaceup() and c:GetFlagEffect(95480000)~=0
end
function c95480114.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(c95480114.filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and ct>0 end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c95480114.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c95480114.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c95480114.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c95480114.thfilter(c)
	return c:IsSetCard(0xd5f) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(95480114)
end
function c95480114.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95480114.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95480114.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95480114.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

