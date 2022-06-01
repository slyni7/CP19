--μ(마이크로)nicorn is Alive!
local m=11111125
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.con2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,0x1f5)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and g:GetClassCount(Card.GetCode)>14
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,0x1f5)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Group.CreateGroup()
	for i=1,15 do
		local tg=g:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local fg=g:Filter(Card.IsCode,nil,tc:GetCode())
		g:Sub(fg)
		sg:AddCard(tc)
	end
	Duel.ConfirmCards(1-tp,sg)
	Duel.BreakEffect()
	local WIN_REASON_MUNICORN=0xff
	Duel.Win(tp,WIN_REASON_MUNICORN)
end