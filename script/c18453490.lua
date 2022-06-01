--증식의 A
local m=18453490
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	WriteEff(e1,1,"CO")
	c:RegisterEffect(e1)
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_EARTH}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.ocon11)
	e1:SetOperation(cm.oop11)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(cm.ocon12)
	e2:SetOperation(cm.oop12)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=MakeEff(c,"FC")
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(cm.ocon13)
	e3:SetOperation(cm.oop13)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.onfil11(c,tp)
	return c:IsControler(1-tp)
end
function cm.ocon11(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.onfil11,1,nil,tp) 
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LSTN("H"),0)<6 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.ocon12(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.onfil11,1,nil,tp) and Duel.GetFlagEffect(tp,m)==0 
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.ocon13(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.oop13(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,m)
	if Duel.GetFieldGroupCount(tp,LSTN("H"),0)<6 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end