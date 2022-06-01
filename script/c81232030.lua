--기연의 어릿광대
--카드군 번호: 0x1cba
local m=81232030
local cm=_G["c"..m]
function cm.initial_effect(c)

	--세트
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	
	--유발 효과
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(cm.cn3)
	c:RegisterEffect(e3)
end

--드로우
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(0x08)
end
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:GetHandler():IsSetCard(0xcba)
end
function cm.filchk(c)
	return c:IsFaceup() and c:IsCode(81232080)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
	end
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(cm.filchk,tp,0x0c+0x10,0x0c+0x10,1,nil)
	local d=1
	if b2 and Duel.GetFieldGroupCount(tp,0x01,0)>1
	and Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==1 then
		d=2
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(d)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,d)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAINIFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p~=rp then p=e:GetHandlerPlayer() end
	Duel.Draw(p,d,REASON_EFFECT)
end
