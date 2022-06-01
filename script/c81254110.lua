--위엄의 순광(선령)
--카드군 번호: 0xc9f
local m=81254110
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,81254000)

	--패에서 발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(cm.cn1)
	c:RegisterEffect(e1)
	
	--발동 무효
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--소환 무효
	local e3=e2:Clone()
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	--한데스
	local e4=e2:Clone()
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetCondition(cm.cn4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end

--패에서 발동
function cm.cn1(e)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if #g~=1 then
		return false
	end
	local c=g:GetFirst()
	return c:IsFaceup() and c:IsSetCard(0xc9f)
end

--발동 무효
function cm.nfil0(c)
	return c:IsFaceup() and c:IsSetCard(0xc9f)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
	and Duel.IsExistingMatchingCard(cm.nfil0,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end

--소환 무효
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetCurrentChain()==0
	and Duel.IsExistingMatchingCard(cm.nfil0,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end

--한데스
function cm.nfil1(c,tp)
	return c:IsControler(tp)
end
function cm.cn4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil1,1,nil,1-tp) and Duel.GetCurrentPhase()~=PHASE_DRAW
	and Duel.IsExistingMatchingCard(cm.nfil0,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,0,0x02)>0
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,0x02)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,0x02)
	if #g>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,2,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.ShuffleHand(1-p)
	end
end
