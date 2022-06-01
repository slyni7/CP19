--타임글래스 하이네스
local m=47290012
local cm=_G["c"..m]

function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,">",nil,aux.FilterBoolFunction(Card.IsSetCard,0x429),cm.ordfil1,aux.FilterBoolFunction(Card.IsSetCard,0x429))

	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)

	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)

	--skip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.skcon)
	e2:SetTarget(cm.sktg)
	e2:SetOperation(cm.skop)
	c:RegisterEffect(e2)


	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetTargetRange(0xff,0xff)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	

end
cm.CardType_Order=true

function cm.ordfil1(c)
	return c:IsType(TYPE_ORDER) and c:IsSetCard(0x429)
end

function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_ORDER)==SUMMON_TYPE_ORDER
end

function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end




function cm.skcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=4
end

function cm.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(cm.chlimit)
end

function cm.chlimit(e,ep,tp)
	return tp==ep
end

function cm.skop(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetTurnPlayer()

	Duel.SkipPhase(t,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(t,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(t,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(t,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(t,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(t,PHASE_END,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	if t==1-tp then
		e1:SetTargetRange(0,1)
	else
		e1:SetTargetRange(1,0)
	end
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,t)

end