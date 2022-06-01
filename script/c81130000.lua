function c81130000.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81130000,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c81130000.cn)
	e1:SetOperation(c81130000.op)
	c:RegisterEffect(e1)

	--effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81130000,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,81130000)
	e3:SetTarget(c81130000.etg)
	e3:SetOperation(c81130000.eop)
	c:RegisterEffect(e3)
end

--summon method
function c81130000.cn(e,c,minc)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c81130000.op(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(e:GetHandler():GetBaseAttack()/2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(e:GetHandler():GetBaseDefense()/2)
	c:RegisterEffect(e2)
end

--effect 1
function c81130000.dfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsDestructable()
end
function c81130000.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81130000.dfilter,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c81130000.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tp,g,g:GetCount(),0)
	e:GetHandler():RegisterFlagEffect(81130000,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end

function c81130000.eop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81130000.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
