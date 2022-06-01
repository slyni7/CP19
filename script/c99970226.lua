--String Harmonies
local m=99970226
local cm=_G["c"..m]
function cm.initial_effect(c)

	--덱 발동
	local e1=YuL.ActST(c)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+YuL.O)
	e1:SetCost(YuL.discard(1,1))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--자가 회수
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGOTY_TOHAND)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	
end

--덱 발동
function cm.actfilter(c,tp)
	return c:IsSetCard(0xd3f) and c:IsType(YuL.ST) and c:GetActivateEffect():IsActivatable(tp)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.actfilter,tp,LSTN("D"),0,1,nil,tp)
		and Duel.GetLocationCount(tp,LSTN("S"))>0 end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LSTN("D"),0,1,1,nil,tp):GetFirst()
	if tc then
        local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local opt=0
		if te then
    	    local con=te:GetCondition()
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			Duel.ClearTargetCard()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			if bit.band(tpe,TYPE_FIELD)~=0 then
				local of=Duel.GetFieldCard(tp,LSTN("S"),5)
				if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			end
			Duel.MoveToField(tc,tp,tp,LSTN("S"),POS_FACEUP,true)
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

--자가 회수
function cm.spcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd3f) and c:IsAbleToHandAsCost()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.spcfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
