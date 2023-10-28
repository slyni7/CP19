--[ LIVES HELL ]
local s,id=GetID()
function s.initial_effect(c)

	RevLim(c)
	aux.AddModuleProcedure(c,s.module,nil,1,1,nil)
	
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
	
	local e3=MakeEff(c,"Qo","M")
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCL(1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	
	local e2=MakeEff(c,"FTf","G")
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCL(1)
	e2:SetCondition(function(e) return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and e:GetHandler():GetFlagEffect(id)~=0 end)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
end

function s.module(c)
	return c:IsRace(RACE_FIEND) and c:IsLevel(5)
end

function s.lives_hell_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end

function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
		and Duel.IsExistingTarget(s.module,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.module),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if Duel.Equip(tp,sc,c,true)==0 then return end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(s.eqlimit)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
		if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Equip(tp,tc,c,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EQUIP_LIMIT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(s.eqlimit)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	else Duel.SendtoGrave(tc,REASON_RULE) end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end


function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function s.op2fil(c)
	return c:GetBattledGroupCount()>0
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsST,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	if not Duel.IsExistingMatchingCard(s.op2fil,tp,0,LOCATION_MZONE,1,nil) and #g>0 then
		Duel.SendtoGrave(g,REASON_RULE,PLAYER_NONE,1-tp)
	end
end


