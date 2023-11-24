--[ D:011 ]
local s,id=GetID()
function s.initial_effect(c)

	local e0=MakeEff(c,"Qo","H")
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCL(1,id)
	WriteEff(e0,0,"CTO")
	c:RegisterEffect(e0)
	
	local e1=MakeEff(c,"STo")
	e1:SetD(id,0)
	e1:SetCategory(CATEGORY_ATKCHANGE|CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	local e2=MakeEff(c,"STo")
	e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_REMOVE)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)

	if not s.global_check then
		s.global_check=true
		s[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		ge1:SetOperation(s.gop)
		Duel.RegisterEffect(ge1,0)
	end
	
end

function s.gop(e,tp,eg,ep,ev,re,r,rp)
	s[0]=s[0]+#eg
end

function s.cost0fil(c)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end
function s.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cost0fil,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cost0fil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tar0(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
			Duel.BreakEffect()
			YuL.FlipSummon(e,tp)
		end
	end
end	

function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local dg=Group.CreateGroup()
	if g:GetCount()>0 then
		for tc in g:Iter() do		
			local pa,pd=tc:GetAttack(),tc:GetDefense()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			e1:SetValue(-400*s[0])
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			if (pa~=0 and tc:GetAttack()==0) or (pd~=0 and tc:GetDefense()==0) then dg:AddCard(tc) end
		end
	end
	if #dg==0 then return end
	Duel.BreakEffect()
	Duel.Destroy(dg,REASON_EFFECT)
end

function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(function(e,c) return c:IsFacedown() end)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE|RESET_PHASE|PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE|EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	Duel.RegisterEffect(e2,tp)
end
	
