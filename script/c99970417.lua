--[ Tinnitus ]
local m=99970417
local cm=_G["c"..m]
function cm.initial_effect(c)

	--엑시즈 소환
	RevLim(c)
	aux.AddXyzProcedure(c,aux.FBF(Card.IsSetCard,0xe1c),4,3)

	--타깃 설정
	local e0=MakeEff(c,"FC","M")
	e0:SetCode(EVENT_ADJUST)
	WriteEff(e0,0,"NO")
	c:RegisterEffect(e0)

	--무효화
	local e1=MakeEff(c,"F","M")
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.distg)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(cm.discon)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)

	--소재 제거 + 드로우
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(YuL.turn(0))
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
	
end

--타깃 설정
function cm.con0fil(c)
	return c:GetCounter(0x1e1c)>0
end
function cm.con0(e)
	return not Duel.IsExistingMatchingCard(cm.con0fil,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(cm.op0fil,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil,e)
end
function cm.op0fil(c,e)
	return not c:IsImmuneToEffect(e) and c:IsFaceup()
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.op0fil,tp,0,LOCATION_MZONE,nil,e)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,m)
		local sg=g:Select(tp,1,2,nil)
		Duel.HintSelection(sg)
		sg:GetFirst():AddCounter(0x1e1c,1,REASON_EFFECT)
		if #sg>1 then sg:GetNext():AddCounter(0x1e1c,1,REASON_EFFECT) end
	end
end

--무효화
function cm.con1(e)
	return e:GetHandler():GetOverlayCount()>0
end
function cm.filter(c,code1,code2)
	return c:GetCounter(0x1e1c)>0 and c:IsFaceup() and c:GetOriginalCodeRule()==code1,code2
end
function cm.distg(e,c)
	local code1,code=c:GetOriginalCodeRule()
	return c:IsFaceup() and c:GetControler()~=e:GetHandlerPlayer()
		and Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil,code1,code2)
		and not c:IsSetCard(0xe1c)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) or rp==tp or e:GetHandler():GetOverlayCount()==0 then return false end
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,code1,code2)
		and not re:GetHandler():IsSetCard(0xe1c)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)
end

--소재 제거 + 드로우
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)~=0 then
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
