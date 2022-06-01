--네파시아 파멸자
function c47550013.initial_effect(c)

	--cannot special summon
	local e99=Effect.CreateEffect(c)
	e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e99:SetType(EFFECT_TYPE_SINGLE)
	e99:SetCode(EFFECT_SPSUMMON_CONDITION)
	e99:SetValue(aux.linklimit)
	c:RegisterEffect(e99)

	--link summon
	aux.AddLinkProcedure(c,nil,3,99,c47550013.lcheck)
	c:EnableReviveLimit()

	--attribute dark
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetCondition(c47550013.eqcon)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)

	--light:atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c47550013.ndcon)
	e1:SetTarget(c47550013.ndtar)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)   

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c47550013.effectfilter)
	e3:SetCondition(c47550013.ndcon)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c47550013.effectfilter)
	e4:SetCondition(c47550013.ndcon)
	c:RegisterEffect(e4)

	--dark:tograve
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c47550013.tgcost)
	e5:SetCondition(c47550013.tgcon)
	e5:SetTarget(c47550013.tgtg)
	e5:SetOperation(c47550013.tgop)
	c:RegisterEffect(e5) 
end

function c47550013.eqcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<3
end

function c47550013.lcheck(g,lc)
	return g:IsExists(c47550013.mzfilter,1,nil)
end
function c47550013.mzfilter(c)
	return c:IsLinkSetCard(0x487) and c:IsLinkType(TYPE_LINK)
end

function c47550013.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c47550013.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c47550013.tar11)
	Duel.RegisterEffect(e1,tp)
end
function c47550013.tar11(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(47550013) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function c47550013.ndcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47550013.ndtar(e,c)
	return (c:IsLinkState() and c:IsSetCard(0x487)) or c==e:GetHandler()
end

function c47550013.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x487)
end


function c47550013.cfilter(c,g)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and g:IsContains(c) and c:IsSetCard(0x487)
end
function c47550013.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 and Duel.CheckReleaseGroup(tp,c47550013.cfilter,2,nil,lg) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	local g=Duel.SelectReleaseGroup(tp,c47550013.cfilter,2,2,nil,lg)
	Duel.Release(g,REASON_COST)

end

function c47550013.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c47550013.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function c47550013.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end