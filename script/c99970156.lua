--판데믹스: 중2병
local m=99970156
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--융합 소환
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,3,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.spcon)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)

	--융합 제한
	YuL.ExLimit(c)
	
	--융합 소재

	--●2 서치 or 샐비지 (+ 파괴)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetHintTiming(TIMING_DRAW_PHASE,TIMING_DRAW_PHASE)
	e2:SetCost(YuL.LPcost(700))
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	e2:SetCondition(cm.thcon)
	c:RegisterEffect(e2)
	--●1 리로드
	local e1=e2:Clone()
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	--공수 증가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.atktg)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	
	--판데믹: 회복
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetTarget(cm.rectg)
	e5:SetOperation(cm.recop)
	c:RegisterEffect(e5)
	
end

--융합 소환
function cm.ffilter(c)
	return c:IsFusionSetCard(0xd3c) and c:IsType(TYPE_MONSTER)
end
function cm.cfilter(c)
	return c:IsFusionSetCard(0xd3c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function cm.fselect(c,tp,mg,sg,...)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(cm.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		return true
	end
	sg:RemoveCard(c)
	return res
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(cm.fselect,1,nil,tp,mg,sg)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,cm.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end

--①
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DRAW
end

--●1 리로드
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	Duel.Draw(p,g:GetCount(),REASON_EFFECT)
end

--●2 서치 or 샐비지 (+ 파괴)
function cm.thfilter(c)
	return c:IsSetCard(0xd3c) and c:IsAbleToHand()
end
function cm.desfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler())
		Duel.Destroy(g1,REASON_EFFECT)
	end
end

--공수 증가
function cm.atktg(e,c)
	return c:IsSetCard(0xd3c) and c~=e:GetHandler()
end

--판데믹스: 회복
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1400)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1400)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
