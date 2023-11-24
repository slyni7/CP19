--[ D:011 ]
local s,id=GetID()
function s.initial_effect(c)

	RevLim(c)
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xcd6e),7,2)
	c:SetSPSummonOnce(id)
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCode(EFFECT_EXTRA_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e0:SetTargetRange(1,0)
	e0:SetValue(s.extraval)
	c:RegisterEffect(e0)
	
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(id,0)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	e1:SetCost(aux.dxmcostgen(1,1,nil))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	
	local e2=MakeEff(c,"STo")
	e2:SetD(id,1)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(s.val3)
	c:RegisterEffect(e3)

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

function s.extraval(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_XYZ or sc~=e:GetHandler() then
			return Group.CreateGroup()
		else
			return Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
		end
	end
end
function s.tar1fil(c)
	return c:IsAbleToRemove() and aux.SpElimFilter(c,false,true)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return s[0]>=2 and Duel.IsExistingMatchingCard(s.tar1fil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=s[0]//2
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.tar1fil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,ct,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function s.tar2fil(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tar2fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tar2fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>3 then
		local ct=#g-3
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,ct,ct,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end

function s.val3(e,c)
	local ct=s[0]//3
	return math.max(0,ct-1)
end

