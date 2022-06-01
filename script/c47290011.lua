--타임글래스 오블리비언
local m=47290011
local cm=_G["c"..m]

function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,"<",nil,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),aux.FilterBoolFunction(Card.IsSetCard,0x429))

	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)

	--cannot be destroyed by effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	--eff change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.chtg)
	e2:SetOperation(cm.chop)
	c:RegisterEffect(e2)

end
cm.CardType_Order=true

function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_ORDER)==SUMMON_TYPE_ORDER
end



function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x429) end
	local rg=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x429)
	Duel.Release(rg,REASON_COST)
end

function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil) end
end

function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end

function cm.repop(e,tp,eg,ep,ev,re,r,rp)

	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil)

	if g1:GetCount()>0 then
		Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT)
	end
end