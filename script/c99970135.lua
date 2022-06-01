--성광현계(프로퍼시: 오버레이)
local m=99970135
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--서치 / 발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	
	--공 / 수 증가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd3a))
	e2:SetValue(200)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
end

--발동 / 서치
function cm.thfilter(c,e,tp)
	return c:IsSetCard(0xd3a) and c:GetType()==0x20002
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
