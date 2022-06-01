--[ RainbowFish ]
local m=99970612
local cm=_G["c"..m]
function cm.initial_effect(c)

	YuL.Activate(c)
	
	--물고기 빔!
	local e1=MakeEff(c,"Qo","S")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--자가 세트
	local e3=MakeEff(c,"STo","G")
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCL(1,m)
	e3:SetCondition(YuL.turn(1))
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	
end

--물고기 빔!
function cm.cfil2(c)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATT_W)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.cfil2,tp,LSTN("H"),0,nil)
	mg:Merge(Duel.GetOverlayGroup(tp,1,1):Filter(cm.cfil2,nil))
	if chk==0 then return #mg>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=mg:Select(tp,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thfilter(c,tp)
	return c:IsCode(CARD_FISH_N_KICKS,CARD_FISH_N_BACKS) and c:GetActivateEffect():IsActivatable(tp)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,tp) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,tp)
	local tc=sg:GetFirst()
	if tc then
		if tc:GetActivateEffect():IsActivatable(tp) then
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

--자가 세트
function cm.rfilter(c)
	return c:IsRainbowFish() and c:IsAbleToRemoveAsCost()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end
