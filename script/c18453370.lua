--갈릭 치킨
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,id)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function s.tfil1(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	return c:IsCode(83764718) and (c:IsAbleToHand() or (te and te:IsActivatable(tp,true,true) and Duel.GetLocCount(tp,"S")>0))
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"DGR",0,1,nil,tp)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,0,tp,"DGR")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HITNMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil1,tp,"DGR",0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local te=tc:CheckActivateEffect(false,false,false)
		local b1=tc:IsAbleToHand()
		local b2=te and te:IsActivatable(tp,true,true)
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LSTN("S"),POS_FACEUP,true)
			Duel.HintActivation(te)
			e:SetActiveEffect(te)
			te:UseCountLimit(tp,1,true)
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			tc:CancelToGrave(false)
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
			e:SetProperty(EFFECT_FLAG_DELAY)
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end