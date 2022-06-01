--트랜캐스터 플래시
local m=47300012
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xe3e),nil,1,99)
	c:EnableReviveLimit()
	
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)

	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.effcost)
	e1:SetTarget(cm.srtg)
	e1:SetOperation(cm.srop)
	c:RegisterEffect(e1)

	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.atkcon)
	e2:SetCost(cm.atkcost)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)

	--special summon
	local e99=Effect.CreateEffect(c)
	e99:SetDescription(aux.Stringid(m,2))
	e99:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e99:SetCode(EVENT_LEAVE_FIELD)
	e99:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e99:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e99:SetCountLimit(1,m+1000)
	e99:SetCondition(cm.tcon)
	e99:SetTarget(cm.tg2)
	e99:SetOperation(cm.op2)
	c:RegisterEffect(e99)

end

cm.square_mana={0x0,0x0,0x0,0x0,0x0,0x0,0x0}
cm.custom_type=CUSTOMTYPE_SQUARE



function cm.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetExactManaCount(ATTRIBUTE_LIGHT)>=2 end

	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(cm.tval1)
	c:RegisterEffect(e1)

	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_EXTRA_SQUARE_MANA)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	e2:SetValue(cm.oval1)
	c:RegisterEffect(e2)

end

function cm.tval1(e,c)
	return ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT
end
function cm.oval1(e,c)
	return 0x0,0x0
end

function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
end

function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end





function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end

function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetExactManaCount(ATTRIBUTE_EARTH)>=2 end

	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(cm.tval2)
	c:RegisterEffect(e1)

	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_EXTRA_SQUARE_MANA)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	e2:SetValue(cm.oval1)
	c:RegisterEffect(e2)

end

function cm.tval2(e,c)
	return ATTRIBUTE_EARTH,ATTRIBUTE_EARTH
end

function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end







function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.tfilter2(c,e,tp)
	return c:IsSetCard(0xe3e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(5) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	local g=Duel.GetMatchingGroup(cm.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if g:GetCount()<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end