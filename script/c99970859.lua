--[ LIVES HELL ]
local s,id=GetID()
function s.initial_effect(c)

	local e1=MakeEff(c,"A")
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	e2:SetCost(aux.bfgcost)
	e2:SetCL(1,id)
	c:RegisterEffect(e2)
	
end

function s.tar1fil(c)
	return c:IsLevel(5) and c:IsRace(RACE_FIEND) and not c:IsForbidden()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.tar1fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_DECK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsLocation(LOCATION_HAND) then ft=ft-1 end
	local ct=math.min(2,ft)
	if ct>0 and #g>0 then
		local eqg=Duel.SelectMatchingCard(tp,s.tar1fil,tp,LOCATION_DECK,0,1,ct,nil)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		for eqc in eqg:Iter() do		
			Duel.Equip(tp,eqc,tc,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.eqlimit)
			eqc:RegisterEffect(e1)
		end
	end
end
function s.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() or e:GetHandler():GetEquipTarget()==c
end

function s.filter(c,e,tp)
	return c:IsLevel(5) and c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	if ft>3 then ft=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
