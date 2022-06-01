--QC Tigeris
function c81140050.initial_effect(c)

	c:EnableReviveLimit()
	
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81140050.ecn)
	e1:SetTarget(c81140050.lim1)
	e1:SetTargetRange(0,1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(81140050)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	if c81140050.global_check==nil then
		c81140050.global_check=true
		c81140050[0]=1
		c81140050[1]=1
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(c81140050.reset)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetOperation(c81140050.check)
		Duel.RegisterEffect(ge2,0)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c81140050.val)
	c:RegisterEffect(e3)
	
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81140050,0))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,81140050)
	e4:SetCondition(c81140050.vcn)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c81140050.vtg)
	e4:SetOperation(c81140050.vop)
	c:RegisterEffect(e4)
end

--summon limit
function c81140050.ecn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetHandler():GetFlagEffect(81140050)~=0
end

function c81140050.lim1(e,c,sump,sumtype,sumpos,targetp,se)
	return ( c:IsLocation(0x02) or c:IsLocation(0x40) ) and c81140050[sump]<=0
end
function c81140050.reset(e,tp,eg,ep,ev,re,r,rp)
	c81140050[0]=1
	c81140050[1]=1
end
function c81140050.check(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_EXTRA) then
			local p=tc:GetSummonPlayer()
			c81140050[p]=c81140050[p]-1
		end
		tc=eg:GetNext()
	end
end

function c81140050.val(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0xcb1) then
		c:RegisterFlagEffect(81140050,RESET_EVENT+0x6e0000,0,1)
	end
end

--search
function c81140050.vcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c81140050.filter(c)
	return c:IsSetCard(0xcb1) and c:IsAbleToHand() and not c:IsCode(81140050)
end
function c81140050.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81140050.filter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81140050.vop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81140050.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
