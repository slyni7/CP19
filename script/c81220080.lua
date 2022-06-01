--율자인자
--카드군 번호: 0xcbb
function c81220080.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81220080)
	e1:SetCost(c81220080.co1)
	e1:SetTarget(c81220080.tg1)
	e1:SetOperation(c81220080.op1)
	c:RegisterEffect(e1)
	
	--유발
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81220080,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81220081)
	e2:SetCondition(c81220080.cn2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81220080.tg2)
	e2:SetOperation(c81220080.op2)
	c:RegisterEffect(e2)
end

--발동
function c81220080.filter0(c)
	return c:IsDiscardable() and c:IsSetCard(0xcbb)
end
function c81220080.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81220080.filter0,tp,LOCATION_HAND,0,1,e:GetHandler())
	end
	Duel.DiscardHand(tp,c81220080.filter0,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c81220080.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c81220080.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--전투
function c81220080.cn2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	local a=Duel.GetAttacker()
	return ( a:IsSetCard(0xcbb) and a:IsControler(tp) and a:IsFaceup() )  
	or ( d:IsSetCard(0xcbb) and d:IsControler(tp) and d:IsFaceup() )
end
function c81220080.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then
		return false
	end
	local d=Duel.GetAttackTarget()
	local a=Duel.GetAttacker()
	if chk==0 then
		return a:IsAbleToDeck() or ( d~=nil and d:IsAbleToDeck() )
	end
	local g=Group.CreateGroup()
	if a:IsRelateToBattle() then g:AddCard(a) end
	if d~=nil and d:IsRelateToBattle() then g:AddCard(d) end
	Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c81220080.op2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.FromCards(a,d)
	local rg=g:Filter(Card.IsRelateToBattle,nil)
	Duel.SendtoDeck(rg,nil,0,REASON_EFFECT)
end


