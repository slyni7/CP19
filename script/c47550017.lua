--네파시아 할루시네이션
function c47550017.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	--removehand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,47550017)
	e1:SetCondition(c47550017.rmcon)
	e1:SetTarget(c47550017.rmtg)
	e1:SetOperation(c47550017.rmop)
	c:RegisterEffect(e1)

	--drawinsteadchain
	local e2=Effect.CreateEffect(c)
	e2:SetCountLimit(1,47550017)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c47550017.drcon)
	e2:SetTarget(c47550017.drtg)
	e2:SetOperation(c47550017.drop)
	c:RegisterEffect(e2)

end

function c47550017.rmcon(e)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>2
end

function c47550017.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lim=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-1

	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil,tp,POS_FACEDOWN) and lim>0 end

	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end

function c47550017.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
	local lim=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-1
	if lim<1 then return end
	local g=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,p,LOCATION_HAND,0,1,lim,POS_FACEDOWN)

	if g:GetCount()>0 then
		if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT) then

			if Duel.SelectYesNo(tp,aux.Stringid(47550017,0)) then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
				local lim2=g:GetCount()
				if lim2<1 then return end
				local g2=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,p,0,LOCATION_GRAVE,1,lim2,POS_FACEDOWN)

				if g2:GetCount()>0 then
					Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
				end
			end

			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			e1:SetCountLimit(1)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c47550017.retcon)
			e1:SetOperation(c47550017.retop)
			e1:SetLabelObject(g)
			Duel.RegisterEffect(e1,tp)
			g:KeepAlive()

			local tc=g:GetFirst()
			while tc do
				tc:RegisterFlagEffect(47550017,RESET_EVENT,RESETS_STANDARD,0,1)
				tc=g:GetNext()
			end
		end
	end
end


function c47550017.retfilter1(c)
	return c:GetFlagEffect(47550017)~=0
end

function c47550017.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel()
end

function c47550017.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c47550017.retfilter,nil)

	g:DeleteGroup()
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end



function c47550017.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetCurrentChain()>1 and Duel.GetChainInfo(Duel.GetCurrentChain()-1,CHAININFO_TRIGGERING_CONTROLER) == tp
		and Duel.GetChainInfo(Duel.GetCurrentChain()-1,CHAININFO_TRIGGERING_EFFECT):GetHandler():IsSetCard(0x487)
end

function c47550017.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
end

function c47550017.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c47550017.repop)
end

function c47550017.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)

	if e:IsActiveType(TYPE_SPELL+TYPE_TRAP) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave(false)
	end
end