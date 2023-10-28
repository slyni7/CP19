--[ LIVES HELL ]
local s,id=GetID()
function s.initial_effect(c)

	YuL.Activate(c)

	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.actcon)
	c:RegisterEffect(e0)
	
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e00:SetCode(EVENT_TO_GRAVE)
	e00:SetOperation(s.lives_hell_op)
	c:RegisterEffect(e00)
	
	local e1=MakeEff(c,"Qo","S")
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	local e2=MakeEff(c,"F","S")
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) return c:IsLevel(5) and c:IsRace(RACE_FIEND) end)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	
	local e3=MakeEff(c,"F","G")
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(aux.TRUE)
	e3:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e3)

end

function s.lives_hell_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD) 
		and c:IsPreviousControler(tp) and rp==1-tp then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end

function s.actfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsCode(76052811)
end
function s.actcon(e)
	return Duel.IsExistingMatchingCard(s.actfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end

function s.cost1fil(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToGraveAsCost()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cost1fil,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cost1fil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tar1fil(c,e,tp)
	return c:IsCode(76052811) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tar1fil,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.tar1fil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end

function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.actfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)*2000
end

function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and e:GetHandler():GetFlagEffect(id)~=0
end
