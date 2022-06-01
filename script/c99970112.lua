--프레이 오브 헤븐
local m=99970112
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--링크 소환
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xd38),1,1)
	
	--서치 / 발동
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	
	--공격력 증가
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	e2:SetCondition(cm.atkcon)
	c:RegisterEffect(e2)
	
end

--서치 / 발동
function cm.cfilter(c)
	return c:IsSetCard(0xd38) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thfilter(c,e,tp)
	return c:IsSetCard(0xd38) and c:IsType(YuL.ST)
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=sg:GetFirst()
	if tc then
		local v1=tc:IsAbleToHand()
		local v2=tc:GetActivateEffect():IsActivatable(tp)
		if v1 and (not v2 or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			local tpe=tc:GetType()
			local te=tc:GetActivateEffect()
			if te then
    			local con=te:GetCondition()
				local co=te:GetCost()
				local tg=te:GetTarget()
				local op=te:GetOperation()
					Duel.ClearTargetCard()
					e:SetCategory(te:GetCategory())
					e:SetProperty(te:GetProperty())
				if bit.band(tpe,TYPE_FIELD)~=0 then
					local of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
					if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
				end
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					Duel.Hint(HINT_CARD,0,tc:GetCode())
					tc:CreateEffectRelation(te)
				if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
					tc:CancelToGrave(false)
				end
				if co then
					co(te,tp,eg,ep,ev,re,r,rp,1)
				end
				if tg then
					tg(te,tp,eg,ep,ev,re,r,rp,1)
				end
				local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if cg then
					local etc=cg:GetFirst()
					while etc do
						etc:CreateEffectRelation(te)
						etc=cg:GetNext()
					end
				end
				Duel.BreakEffect()
				if op then
					op(te,tp,eg,ep,ev,re,r,rp)
				end
				tc:ReleaseEffectRelation(te)
				if etc then
					etc=cg:GetFirst()
					while etc do
						etc:ReleaseEffectRelation(te)
						etc=cg:GetNext()
					end
				end
			end
		end
	end
end

--공격력 증가
function cm.confilter(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function cm.atkcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(cm.confilter,1,nil)
end
function cm.atkval(e)
	local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	return ct*300
end
