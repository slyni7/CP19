--XXX
local m=99970362
local cm=_G["c"..m]
function cm.initial_effect(c)

	--오더 소환
	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,">",nil,aux.FilterBoolFunction(Card.IsSetCard,0xe11),aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT))

	--바운스
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	
	--공격 무효 + 한데스
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.condition2)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)

end

cm.CardType_Order=true

--바운스
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ORDER)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
	local ct={}
	for i=3,1,-1 do
		if Duel.IsPlayerCanDiscardDeckAsCost(tp,i) then
			table.insert(ct,i)
		end
	end
	if #ct==1 then 
		Duel.DiscardDeck(tp,ct[1],REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
		Duel.DiscardDeck(tp,ac,REASON_COST)
	end
	local g=Duel.GetOperatedGroup()
	e:SetLabel(g:FilterCount(Card.IsSetCard,nil,0xe11))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:Select(tp,ct,ct,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end

--공격 무효 + 한데스
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(99970351)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local tg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
		if tg:GetCount()>0 and Duel.NegateAttack() then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local hg=tg:Select(tp,1,1,nil)
			Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
			Debug.Message("달은 인간을 미치게 하지. 마치 은빛 뱀 처럼 내 시간을 집어삽켰다네. 나는 그동안 무엇을 했나? 아니, 무엇이었는가?")
		end
		Duel.ShuffleHand(1-tp)
	end
end
