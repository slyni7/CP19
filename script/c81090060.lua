--Ghost-Charm "Se-Ga"

function c81090060.initial_effect(c)

	--summon method
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcac),4,2,nil,nil,99)
	c:EnableReviveLimit()

	--treat
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetValue(0x10)
	c:RegisterEffect(e1)
	
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81090060.mcn)
	e2:SetOperation(c81090060.mcp)
	c:RegisterEffect(e2)
	
	--2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c81090060.idcn)
	e3:SetValue(c81090060.filter1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(c81090060.filter2)
	c:RegisterEffect(e4)
	
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetCountLimit(1)
	e5:SetCondition(c81090060.dscn)
	e5:SetTarget(c81090060.dstg)
	e5:SetOperation(c81090060.dsop)
	c:RegisterEffect(e5)
	
end

--
function c81090060.mcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c81090060.mcp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:CheckRemoveOverlayCard(tp,1,REASON_COST) then
		c:RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end

--
function c81090060.idcn(e)
	return e:GetHandler():GetOverlayCount()~=0
end

function c81090060.filter1(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end
function c81090060.filter2(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end

--
function c81090060.dscn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c81090060.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=c:GetOverlayGroup():GetClassCount(Card.GetAttribute)
	if chk==0 then
		return ct>0	and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,0x0c,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
end
function c81090060.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetOverlayGroup():GetClassCount(Card.GetAttribute)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
