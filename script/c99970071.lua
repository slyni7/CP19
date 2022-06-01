--Star Absorber
function c99970071.initial_effect(c)

	--스타 앱소버 공격력
	local es=Effect.CreateEffect(c)
	es:SetType(EFFECT_TYPE_SINGLE)
	es:SetCode(EFFECT_UPDATE_ATTACK)
	es:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	es:SetRange(LOCATION_MZONE)
	es:SetValue(c99970071.starabsorber)
	c:RegisterEffect(es)

	--서치 / 발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99970071)
	e1:SetCost(c99970071.thcost)
	e1:SetTarget(c99970071.thtg)
	e1:SetOperation(c99970071.thop)
	c:RegisterEffect(e1)
	
	--공격 제한
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c99970071.bttg)
	c:RegisterEffect(e4)
	
end

--스타 앱소버 공격력
function c99970071.starabsorber(e,c)
	return c:GetLevel()*100
end

--서치 / 발동
function c99970071.cfilter(c)
	return c:IsSetCard(0xd36) and c:IsAbleToRemoveAsCost()
end
function c99970071.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970071.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c99970071.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99970071.thfilter(c,e,tp)
	return c:IsSetCard(0xd36) and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function c99970071.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970071.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970071.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c99970071.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=sg:GetFirst()
	if tc then
		local v1=tc:IsAbleToHand()
		local v2=tc:GetActivateEffect():IsActivatable(tp)
		if v1 and (not v2 or Duel.SelectYesNo(tp,aux.Stringid(99970071,0))) then
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

--공격 제한
function c99970071.bttg(e,c)
	return c:IsFaceup() and c:IsSetCard(0xd36) and c~=e:GetHandler()
		and e:GetHandler():GetLevel()~=e:GetHandler():GetOriginalLevel()
end
