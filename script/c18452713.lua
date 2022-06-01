--µð¼À¹ö¡¡ ÆúÄ«
function c18452713.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetTarget(c18452713.tar1)
	e1:SetOperation(c18452713.op1)
	c:RegisterEffect(e1)
end
function c18452713.tfil1(c,tp,tc)
	if c:IsCode(18452713) then
		return false
	end
	local te=c:CheckActivateEffect(false,false,false)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if tc and tc:IsLocation(LOCATION_HAND) then
		ft=ft-1
	end
	return te and c:IsSetCard(0x2cf) and (ft>0 or c:IsType(TYPE_FIELD)) and c:IsType(TYPE_SPELL) and te:IsActivatable(tp)
end
function c18452713.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18452713.tfil1,tp,LOCATION_DECK,0,1,nil,tp,tc)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c18452713.ofil11(c,g)
	return c:IsAbleToHand() and not c:IsCode(18452713)
end
function c18452713.ofil12(c,g)
	return c:IsSetCard(0x2cf) and c:IsType(TYPE_FUSION) and c:IsFaceup() and c:CheckFusionMaterial(g,nil,PLAYER_NONE)
end
function c18452713.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local tg=Duel.SelectMatchingCard(tp,c18452713.tfil1,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=tg:GetFirst()
	if tc then
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local co=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		if bit.band(tpe,TYPE_FIELD)>0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		Duel.HintActivation(te)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)<1 then
			tc:CancelToGrave(false)
		end
		tc:CreateEffectRelation(te)
		e:SetActiveEffect(te)
		if co then
			co(te,tp,eg,ep,ev,re,r,rp,1)
		end
		if tg then
			tg(te,tp,eg,ep,ev,re,r,rp,1)
		end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local etc=nil
		if g then
			etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op and not tc:IsDisabled() then
			op(te,tp,eg,ep,ev,re,r,rp)
		end
		tc:ReleaseEffectRelation(te)
		if g then
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
		e:SetActiveEffect(nil)
		e:SetCategory(0)
		e:SetProperty(0)
		Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(c18452713.ofil11,tp,LOCATION_DECK,0,nil)
		local fg=Duel.GetMatchingGroup(c18452713.ofil12,tp,LOCATION_MZONE,0,nil,sg)
		if fg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(18452713,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local fc=fg:Select(tp,1,1,nil):GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local mat=Duel.SelectFusionMaterial(tp,fc,sg,nil,PLAYER_NONE)
			Duel.SendtoHand(mat,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,mat)
		end
	end
end