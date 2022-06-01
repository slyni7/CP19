--The War of Red
function c81140090.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81140090,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81140090+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81140090.tg)
	e1:SetOperation(c81140090.op)
	c:RegisterEffect(e1)
	
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81140090,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81140090.fcn)
	e2:SetCost(c81140090.fco)
	e2:SetTarget(c81140090.ftg)
	e2:SetOperation(c81140090.fop)
	c:RegisterEffect(e2)
	if not c81140090.global_check then
		c81140090.global_check=true
		c81140090[0]=0
		c81140090[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c81140090.chk)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c81140090.gop)
		Duel.RegisterEffect(ge2,0)
	end
end

--search
function c81140090.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
	and c:IsSetCard(0xcb1)
end
function c81140090.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81140090.filter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81140090.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81140090.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--draw
function c81140090.chk(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0xcb1) and tc:IsSummonType(SUMMON_TYPE_RITUAL) then
			local p=tc:GetSummonPlayer()
			c81140090[p]=c81140090[p]+1
		end
		tc=eg:GetNext()
	end
end
function c81140090.gop(e,tp,eg,ep,ev,re,r,rp)
	c81140090[0]=0
	c81140090[1]=0
end
function c81140090.fcn(e,tp,eg,ep,ev,re,r,rp)
	return c81140090[tp]>0
end
function c81140090.fco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(81140090,tp,ACTIVITY_SPSUMMON)==0
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(c81140090.lim)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81140090.lim(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function c81140090.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,c81140090[tp])
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c81140090[tp])
end
function c81140090.fop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then
		return
	end
	Duel.Draw(tp,c81140090[tp],REASON_EFFECT)
end
