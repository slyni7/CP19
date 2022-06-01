--아더월드의 기술자
function c76859844.initial_effect(c)
	-- link_summon
	c:EnableReviveLimit()
	c:SetSPSummonOnce(76859844)

	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x2cb),2,2,c76859844.lfil1)
	-- Set_Trap
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EVENT_CHAINING)
	e2:SetDescription(aux.Stringid(76859844,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,76859844)
	e2:SetCondition(c76859844.setcon)
	e2:SetCost(c76859844.setcost)
	e2:SetOperation(c76859844.setop)
	c:RegisterEffect(e2)
	--REVIVE
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76859845,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,76859845)
	e3:SetCondition(c76859844.revcon)
	e3:SetTarget(c76859844.revtar)
	e3:SetOperation(c76859844.revop)
	c:RegisterEffect(e3)
end


function c76859844.lfil1(g)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end


function c76859844.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rc~=c and rc:IsSetCard(0x2cb) and c:IsLinkState()
end

function c76859844.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and c:IsLinkState() end
	Duel.Release(e:GetHandler(),REASON_COST)
end

function c76859844.setfilter(c)
	return (c:GetType()==TYPE_TRAP or c:GetType()==TYPE_TRAP+TYPE_COUNTER or c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS) and c:IsSSetable() and c:IsSetCard(0x2cb)
end

function c76859844.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g2=Duel.SelectMatchingCard(tp,c76859844.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc2=g2:GetFirst()
	if tc2 then
		Duel.SSet(tp,tc2)
		Duel.ConfirmCards(1-tp,tc2)
		local e1=Effect.CreateEffect(tc2)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e1)
	end
end

function c76859844.revcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function c76859844.revtar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c76859844.revop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end

function c76859844.splimit(e,c,tp,sumtp,sumpos)
	return c:IsType(TYPE_LINK) and not c:IsLinkAbove(3)
end
