--[ LIVES HELL ]
local s,id=GetID()
function s.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e00:SetCode(EVENT_TO_GRAVE)
	e00:SetOperation(s.lives_hell_op)
	c:RegisterEffect(e00)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND)
	e1:SetCL(1,id)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_EQUIP)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetRange(LOCATION_MZONE)
	WriteEff(e11,11,"NO")
	c:RegisterEffect(e11)
	
	local e2=MakeEff(c,"FTf","G")
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

function s.lives_hell_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end

function s.cfil(c,ft,tp)
	return c:IsLevel(5) and c:IsRace(RACE_FIEND) and c:IsAbleToGrave()
		and (ft>0 or ( (c:IsControler(tp) and c:GetSequence()<5 and c:IsLocation(LOCATION_MZONE) )) )
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.cfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),ft,tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=Duel.SelectMatchingCard(tp,s.cfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),ft,tp):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	Duel.ShuffleDeck(tp)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0,1)
end
function s.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() or e:GetHandler():GetEquipTarget()==c
end

function s.con11(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function s.chk(c)
	return c:GetFlagEffectLabel(id)==1
end
function s.op11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetMatchingGroup(s.chk,tp,LOCATION_GRAVE,0,nil):GetFirst()
	if not (tc or c:IsRelateToEffect(e)) then return end
	Duel.Equip(tp,tc,c,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(s.eqlimit)
	tc:RegisterEffect(e1)
end

function s.con2fil(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(s.con2fil,1,nil,1-tp) and e:GetHandler():GetFlagEffect(id)~=0
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function s.op2fil(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(s.op2fil,nil,e,1-tp)
	if #sg<=0 then return end
	if #sg<2 or Duel.SelectYesNo(tp,aux.Stringid(id,0)) then sg=sg:RandomSelect(tp,1)
	else sg=sg:RandomSelect(tp,2) end
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
end
