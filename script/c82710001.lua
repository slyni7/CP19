--아르카나 포스 II-더 하이 프리스티스
function c82710001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_COIN+CATEGORY_SEARCH)
	e1:SetTarget(c82710001.tar1)	
	e1:SetOperation(c82710001.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
c82710001.toss_coin=true
function c82710001.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c82710001.ofil11(c)
	return c:IsSetCard(0x5) and (c:IsAbleToHand() or c:IsAbleToGrave()) and c:IsType(TYPE_MONSTER) and not c:IsCode(82710001)
end
function c82710001.ofil12(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	return ((te and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or c:IsAbleToHand()) and c:IsCode(82710019)
end
function c82710001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else
		res=Duel.TossCoin(tp,1)
	end
	c82710001.arcanareg(c,res)
	if res==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c82710001.ofil11,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,aux.Stringid(82710001,0),aux.Stringid(82710001,1))==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local tg=Duel.SelectMatchingCard(tp,c82710001.ofil12,tp,LOCATION_DECK,0,1,1,nil,tp)
		local tc=tg:GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:CheckActivateEffect(false,false,false) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or Duel.SelectOption(tp,aux.Stringid(82710001,0),aux.Stringid(82710001,2))==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				local tpe=tc:GetType()
				local te=tc:GetActivateEffect()
				local co=te:GetCost()
				local tg=te:GetTarget()
				local op=te:GetOperation()
				e:SetCategory(te:GetCategory())
				e:SetProperty(te:GetProperty())
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				Duel.HintActivation(te)
				e:SetActiveEffect(te)
				te:UseCountLimit(tp,1,true)
				if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)<1 then
					tc:CancelToGrave(false)
				end
				tc:CreateEffectRelation(te)
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
				if op then
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
				e:SetCategory(CATEGORY_COIN+CATEGORY_SEARCH)
				e:SetProperty(0)
				Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
			end
		end
	end
end
function c82710001.arcanareg(c,coin)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end