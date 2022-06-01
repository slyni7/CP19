--새까맣게 그을린 흔적

function c81040050.initial_effect(c)

	--treat for lv 4
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c81040050.lvvl)
	c:RegisterEffect(e1)
	
	--damage reduce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81040050,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,81040050+EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c81040050.rdcn)
	e2:SetCost(c81040050.rdco)
	e2:SetOperation(c81040050.rdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81040050,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,81040050+EFFECT_COUNT_CODE_SINGLE)
	e4:SetTarget(c81040050.thtg)
	e4:SetOperation(c81040050.thop)
	c:RegisterEffect(e4)
	
end

--treat for lv 4
function c81040050.lvvl(e,c)
	if c:IsSetCard(0xca4) then return 0x40000+e:GetHandler():GetLevel()
end
end

--damage reduce
function c81040050.rdcn(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) 
	and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex and (cp==tp or cp==PLAYER_ALL) then return true end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	return ex
	and (cp==tp or cp==PLAYER_ALL) and Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
end

function c81040050.rdcofilter(c)
	return c:IsSetCard(0xca4) and c:IsDestructable()
end
function c81040050.rdco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable()
		and Duel.IsExistingMatchingCard(c81040050.rdcofilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c81040050.rdcofilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.Destroy(g,REASON_COST)
end

function c81040050.rdop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetLabel(cid)
	e1:SetValue(c81040050.rpcn)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
-- ㅡ ㅡ ㅡ ㅡ ㅡ ▼
function c81040050.rpcn(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if cid==e:GetLabel() then return 0
	else return val end
end



--search
function c81040050.thtgfilter(c)
	return c:IsSetCard(0xca4) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c81040050.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81040050.thtgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81040050.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81040050.thtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
