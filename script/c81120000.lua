function c81120000.initial_effect(c)

	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81120000.scn)
	e1:SetOperation(c81120000.sop)
	c:RegisterEffect(e1)
	--increase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c81120000.val)
	c:RegisterEffect(e2)
	--deck death
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81120000,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81120000)
	e3:SetTarget(c81120000.tg)
	e3:SetOperation(c81120000.op)
	c:RegisterEffect(e3)
	--trick or...?
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81120000,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,81120001)
	e4:SetCondition(c81120000.ecn)
	e4:SetTarget(c81120000.etg)
	e4:SetOperation(c81120000.eop)
	c:RegisterEffect(e4)
end

--summon method
function c81120000.filter(c,tp)
	return ( c:IsLocation(LOCATION_HAND) or c:IsFaceup() )
	and c:IsSetCard(0xcaf) and c:IsAbleToGraveAsCost()
	and Duel.GetMZoneCount(tp,c)>0
end
function c81120000.scn(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c81120000.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),tp)
end
function c81120000.sop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81120000.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end

--increase
function c81120000.val(e,c)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,0,nil,0xcaf)
	return g:GetClassCount(Card.GetCode)*500
end

--deck
function c81120000.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetTargetPlayer(e:GetHandlerPlayer())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK)
end
function c81120000.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcaf)
end
function c81120000.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CATEGORY_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c81120000.filter2,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c81120000.filter2,1,3,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end

--treat
function c81120000.filter4(c)
	return c:IsFaceup() and c:IsCode(81120010)
end
function c81120000.ecn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81120000.filter4,tp,LOCATION_ONFIELD,0,1,nil)
end
function c81120000.filter3(c,tp)
	return not c:IsForbidden() and c:CheckUniqueOnField(tp) and c:IsCode(81120060)
end
function c81120000.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c81120000.filter3,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp)
	end
	Duel.SetChainLimit(c81120000.lim)
end
function c81120000.lim(e,ep,tp)
	return tp==ep
end
function c81120000.eop(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_DECK+LOCATION_HAND
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c81120000.filter3,tp,loc,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
