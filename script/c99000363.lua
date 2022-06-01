--ZERONIER@SPELL
local m=99000363
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,99000355)
	--copy spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	if not SpinelTable then SpinelTable={} end
	table.insert(SpinelTable,e1)
end
function cm.spell_filter(c)
	return c:IsSetCard(0xc13) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spell_filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.spell_filter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function cm.filter(c)
	local tp=c:GetControler()
	return c:IsSetCard(0xc13) and not c:IsCode(99000363) and (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY))
		and Duel.GetFlagEffect(tp,c:GetCode()+99000363)==0 and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetCode())
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetDescription(aux.Stringid(e:GetLabel(),6))
	e0:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	Duel.RegisterFlagEffect(tp,e:GetLabel()+99000363,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		Duel.BreakEffect()
		Duel.RegisterFlagEffect(tp,99000355+99000351,RESET_PHASE+PHASE_END,0,1)
	end
end