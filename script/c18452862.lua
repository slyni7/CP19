--너스퀘어
local m=18452862
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	c:EnableCounterPermit(0x2d7)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_COUNTER)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
cm.square_mana={ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil11(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	local ft=Duel.GetLocCount(tp,"S")
	return c:IsSetCard("컬러큐브") and c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS==TYPE_SPELL+TYPE_CONTINUOUS
		and (c:IsAbleToHand() or (te and ft>0 and te:IsActivatable(tp)))
		and not Duel.IEMCard(cm.tfil12,tp,"OG",0,1,nil,c:GetCode())
end
function cm.tfil12(c,code)
	return (c:IsFaceup() or c:IsLoc("G")) and c:IsCode(code)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil11,tp,"D",0,1,nil,tp)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil11,tp,"D",0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local te=tc:CheckActivateEffect(false,false,false)
		local ft=Duel.GetLocCount(tp,"S")
		if not tc:IsAbleToHand() or (te and ft>0 and te:IsActivatable(tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
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
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
		else
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.tfil2(c)
	return c:IsCanAddCounter(0x2d7,1) and c:IsFaceup() and c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS==TYPE_SPELL+TYPE_CONTINUOUS
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(cm.tfil2,tp,"O",0,nil)
	if chk==0 then
		return #g>0
	end
	Duel.SOI(0,CATEGORY_COUNTER,nil,#g,tp,0x2d7)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(cm.tfil2,tp,"O",0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x2d7,1)
		tc=g:GetNext()
	end
end