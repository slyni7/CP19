--[ Star Absorber ]
local s,id=GetID()
function s.initial_effect(c)

	local es=MakeEff(c,"S","M")
	es:SetCode(EFFECT_UPDATE_ATTACK)
	es:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	es:SetValue(function(e,c) return c:GetLevel()*100 end)
	c:RegisterEffect(es)
	
	local e1=MakeEff(c,"Qo","M")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,id)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.lvdif)
	e2:SetTarget(s.tar2)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--atk limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.lvdif)
	e3:SetValue(s.tar2)
	c:RegisterEffect(e3)
	
end

function s.tar1fil(c)
	return c:IsSetCard(0xd36) and c:IsSpellTrap() and (c:IsAbleToHand() or c:IsSSetable())
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tar1fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.SelectMatchingCard(tp,s.tar1fil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not sc then return end
	aux.ToHandOrElse(sc,tp,
		function(sc) return sc:IsSSetable() end,
		function(sc) Duel.SSet(tp,sc) end,
		aux.Stringid(id,0)
	)
	if sc:IsQuickPlaySpell() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		sc:RegisterEffect(e1)
	elseif sc:IsTrap() then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD)
		sc:RegisterEffect(e2)
	end
end

function s.lvdif(e)
	return e:GetHandler():GetLevel()~=e:GetHandler():GetOriginalLevel()
end
function s.tar2(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0xd36) and c:IsFaceup()
end
