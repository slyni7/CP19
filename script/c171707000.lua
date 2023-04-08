--버서키드 타라
local s,id=GetID()
function s.initial_effect(c)
    
    local e1=MakeEff(c,"Qo","M")
    e1:SetD(id,0)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetCL(1)
    e1:SetCode(EVENT_FREE_CHAIN)
    WriteEff(e1,1,"TO")
    c:RegisterEffect(e1)
    
    --aux.AddBerserkidEffect(c)
    local e2=MakeEff(c,"SC","M")
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(s.BerserkidEffectTarget)
	c:RegisterEffect(e2)
	
end

function s.desfilter(c,tp)
	return (c:IsFaceup() and c:IsSetCard(0x706) and c:IsControler(tp)) or (c:IsControler(1-tp) and c:IsAttackPos())
end
function s.rescon(sg,e,tp,mg)
    return sg:FilterCount(Card.IsControler,nil,tp)==1
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if chk==0 then return aux.SelectUnselectGroup(rg,e,tp,2,2,s.rescon,0) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rg,2,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,s.rescon,1,tp,HINTMSG_DESTROY)
	if #g==2 then
		Duel.HintSelection(g,true)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function s.BerserkidEffectTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) end
	
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3201)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		c:RegisterEffect(e4)

	return true
end

