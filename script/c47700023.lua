--미미크루 하이드아웃
function c47700023.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,47700023+EFFECT_COUNT_CODE_OATH)
	e0:SetOperation(c47700023.acti)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47700023,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c47700023.drcon)
	e4:SetTarget(c47700023.drtg)
	e4:SetOperation(c47700023.drop)
	c:RegisterEffect(e4)
	if not c47700023.global_check then
		c47700023.global_check=true
		c47700023[0]=0
		c47700023[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c47700023.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c47700023.clearop)
		Duel.RegisterEffect(ge2,0)
	end
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(300)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x229))
	c:RegisterEffect(e2)
end

function c47700023.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x229) and c:IsAbleToHand()
end
function c47700023.acti(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c47700023.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(47700023,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function c47700023.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsSetCard(0x229)
end
function c47700023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c47700023.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47700023.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c47700023.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
function c47700023.filterd(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x229) and c:IsFaceup()
end
function c47700023.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47700023.filterd,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end

function c47700023.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x229) and tc:IsSummonType(SUMMON_TYPE_SPECIAL) then
			local p=tc:GetSummonPlayer()
			if c47700023[p]<3 then
			c47700023[p]=c47700023[p]+1
			end
		end
		tc=eg:GetNext()
	end
end
function c47700023.clearop(e,tp,eg,ep,ev,re,r,rp)
	c47700023[0]=0
	c47700023[1]=0
end
function c47700023.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c47700023[tp]>0
end
function c47700023.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c47700023[tp]) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c47700023[tp])
end
function c47700023.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,c47700023[tp],REASON_EFFECT)
end
