--μ(마이크로) 필터
local m=11111114
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function cm.tfil1(c,se)
	return c:IsSetCard(0x1f5) and (c:IsSummonable(true,nil) or (c:IsLevelAbove(5) and c:IsSummonable(true,se)))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local se=e:GetLabelObject()
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,se)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tfil1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,se)
	local tc=g:GetFirst()
	if not tc then
		return
	end
	if not tc:IsSummonable(true,nil) or (tc:IsLevelAbove(5) and tc:IsSummonable(true,se) and Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
		Duel.Summon(tp,tc,true,se)
	else
		Duel.Summon(tp,tc,true,nil)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-500)
	Duel.RegisterEffect(e1,tp)
end