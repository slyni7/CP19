--举府胶 橇肺固胶
local m=18453015
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e2,2,"NCO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","S")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","G")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,m+1)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function cm.nfil2(c)
	return c:IsCode(m) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(cm.nfil2,tp,"O",0,1,nil)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	c:SetStatus(STATUS_EFFECT_ENABLED,true)
end
function cm.ofil2(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup() and c:IsHasExactSquareMana(ATTRIBUTE_LIGHT)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(cm.oop21)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(18452923)
	Duel.RegisterEffect(e2,tp)
	local tg=Duel.GMGroup(cm.ofil2,tp,"M",0,nil)
	if #tg>0 and Duel.GetFlagEffect(tp,m)<1 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=tg:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.BreakEffect()
		local e3=MakeEff(c,"S")
		e3:SetCode(EFFECT_SQUARE_MANA_DECLINE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(cm.oval23)
		sc:RegisterEffect(e3)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		local e4=MakeEff(c,"F")
		e4:SetCode(EFFECT_CANNOT_INACTIVATE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		e4:SetValue(cm.oval24)
		Duel.RegisterEffect(e4,tp)
	end
end
function cm.oop21(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsSetCard("举府胶") and not rc:IsCode(m) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) then
		local tg=re:GetTarget()
		if (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_CARD,0,m)
			if tg then
				tg(e,tp,eg,ep,ev,re,r,rp,1)
			end
			Duel.BreakEffect()
			local op=re:GetOperation()
			if op then
				op(e,tp,eg,ep,ev,re,r,rp)
			end
		end
	end
end
function cm.oval23(e,c)
	return ATTRIBUTE_LIGHT
end
function cm.oval24(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and tc:IsSetCard("举府胶") and not tc:IsCode(m) and te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_SPELL)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
end
function cm.ofil3(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(cm.oop31)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(18452923)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetOperation(cm.oop32)
	Duel.RegisterEffect(e2,tp)
	local sg=Duel.GMGroup(cm.ofil3,tp,"M",0,nil)
	local sc=sg:GetFirst()
	if sc then
		Duel.BreakEffect()
	end
	while sc do
		local e3=MakeEff(c,"S")
		e3:SetCode(EFFECT_EXTRA_SQUARE_MANA)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(cm.oval23)
		sc:RegisterEffect(e3)
		sc=sg:GetNext()
	end
end
function cm.oop31(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(cm.oop32)
	Duel.RegisterEffect(e1,tp)
end
function cm.oop32(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsSetCard("举府胶") and re:IsActiveType(TYPE_SPELL) then
		Duel.Recover(tp,100,REASON_EFFECT)
	end
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	e:SetLabel(1)
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c:CreateEffectRelation(e)
end
function cm.cfil4(c)
	return not c:IsCode(m) and c:IsSetCard("举府胶") and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()<1 then
			return false
		end
		e:SetLabel(0)
		return Duel.IEMCard(cm.cfil4,tp,"D",0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.cfil4,tp,"D",0,1,1,nil)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,rp=tc:CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then
			op(e,tp,eg,ep,ev,re,r,rp)
		end
	end
	if c:IsRelateToEffect(e) then
		local e1=MakeEff(c,"FC","R")
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.ocon41)
		e1:SetOperation(cm.oop41)
		c:RegisterEffect(e1)
	end
end
function cm.ocon41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocCount(tp,"S")>0 and c:IsSSetable()
end
function cm.oop41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SSet(tp,c)
end