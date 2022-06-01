--님프 메모리즈: 엘레니아
function c99970060.initial_effect(c)

	--님프 메모리즈 공통효과
	local en=Effect.CreateEffect(c)
	en:SetType(EFFECT_TYPE_SINGLE)
	en:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(en)
	local em=Effect.CreateEffect(c)
	em:SetType(EFFECT_TYPE_FIELD)
	em:SetCode(EFFECT_SPSUMMON_PROC)
	em:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	em:SetRange(LOCATION_HAND)
	em:SetCondition(c99970060.NMcon)
	em:SetOperation(c99970060.NMop)
	c:RegisterEffect(em)

	--공수 증가
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970060,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetOperation(c99970060.operation)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)

	--데미지
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99970060,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c99970060.con)
	e2:SetOperation(c99970060.damop)
	e2:SetTarget(c99970060.damtg)
	c:RegisterEffect(e2)
	
end

--님프 메모리즈 공통 효과
function c99970060.NMfilter(c)
	return c:IsSetCard(0xd35) and c:IsDiscardable()
end
function c99970060.NMcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c99970060.NMfilter,c:GetControler(),LOCATION_HAND,0,1,c)
end
function c99970060.NMop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c99970060.NMfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end

--공수 증가
function c99970060.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd35)
end
function c99970060.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99970060.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end

--데미지
function c99970060.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c99970060.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c99970060.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
