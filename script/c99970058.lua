--님프 메모리즈: 마리
function c99970058.initial_effect(c)

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
	em:SetCondition(c99970058.NMcon)
	em:SetOperation(c99970058.NMop)
	c:RegisterEffect(em)

	--표시형식 변경 + 회복
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970058,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c99970058.postg)
	e1:SetOperation(c99970058.posop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)

	--내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99970058,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c99970058.con)
	e2:SetOperation(c99970058.op)
	c:RegisterEffect(e2)
	
end

--님프 메모리즈 공통 효과
function c99970058.NMfilter(c)
	return c:IsSetCard(0xd35) and c:IsDiscardable()
end
function c99970058.NMcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c99970058.NMfilter,c:GetControler(),LOCATION_HAND,0,1,c)
end
function c99970058.NMop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c99970058.NMfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end

--표시형식 변경 + 회복
function c99970058.posfilter(c)
	return c:IsAttackPos() or c:IsFacedown()
end
function c99970058.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970058.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c99970058.posop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(c99970058.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	if Duel.ChangePosition(g,POS_FACEUP_DEFENSE)~=0 then
		Duel.BreakEffect()
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end

--내성 부여
function c99970058.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c99970058.op(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd35))
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end

