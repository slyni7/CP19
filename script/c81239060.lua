--常世理
--상세이치
--카드군 번호: 0xc88
local m=81239060
local cm=_G["c"..m]
function cm.initial_effect(c)

	--공통 트리거(마법/함정)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(0x10)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	--발동시 효과
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--공통 트리거(마법/함정)
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.actfilter(c,tp)
	return c:IsType(0x2+0x4) and c:IsSetCard(0xc88) and c:GetActivateEffect():IsActivatable(tp)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x08)>0
		and Duel.IsExistingMatchingCard(cm.actfilter,tp,0x02+0x10,0,1,nil,tp)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local g=Duel.SelectMatchingCard(tp,cm.actfilter,tp,0x02+0x10,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local opt=0
		if te then
			local cn=te:GetCondition()
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			Duel.ClearTargetCard()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			if bit.band(tpe,TYPE_FIELD)~=0 then
				local of=Duel.GetFieldCard(tp,0x08,5)
				if of and Duel.Destroy(of,REASON_RULE)==0 then
					Duel.SendtoGrave(tc,REASON_RULE)
				end
			end
			Duel.MoveToField(tc,tp,tp,0x08,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
				tc:CancelToGrave(false)
			end
			if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				local etc=g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=g:GetNext()
				end
			end
			Duel.BreakEffect()
			Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVING,e,REASON_EFFECT,tp,tp,0)
			if op then op(te,tp,eg,ep,ev,re,r,rp) end
			tc:ReleaseEffectRelation(te)
			if etc then
				etc=g:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc=g:GetNext()
				end
			end
		end
	end
end

--발동시 효과
function cm.tfil0(c)
	return c:IsSetCard(0xc88) and c:IsType(0x2+0x4) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,0x01)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
