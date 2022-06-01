--μ(마이크로) CW(크리에이트 워터)
local m=11111121
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,cm.pfun1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCountLimit(1)
	e2:SetLabelObject(e1)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tar2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_SUMMON+CATEGORY_TOGRAVE)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCountLimit(1)
	e3:SetLabelObject(e1)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tar3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetLabelObject(e1)
	e4:SetCondition(cm.con4)
	e4:SetCost(cm.cost4)
	e4:SetTarget(cm.tar4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
function cm.pfun1(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1f5)
end
function cm.val1(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(Card.IsSummonType,nil,SUMMON_TYPE_NORMAL)
	e:SetLabel(ct)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()>0
end
function cm.tfil2(c,zone)
	return c:IsSetCard(0x1f5) and c:IsSummonable(true,nil,0,zone)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil2,tp,LOCATION_HAND,0,1,nil,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local zone=c:GetLinkedZone(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tfil2,tp,LOCATION_HAND,0,1,1,nil,zone)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,0,zone)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()>1
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsOnField() and chkc:IsAbleToGrave() and chkc~=c
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,c)
			and Duel.IsExistingMatchingCard(cm.tfil2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.tfil2,tp,LOCATION_DECK,0,1,1,nil)
		local sc=g:GetFirst()
		if sc then
			Duel.Summon(tp,sc,true,nil)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.otar31)
	Duel.RegisterEffect(e1,tp)
end
function cm.otar31(e,c)
	return not c:IsSetCard(0x1f5)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()>2
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>2
	end
	Duel.Release(c,REASON_COST)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x1f5,0x4011,1500,1500,4,RACE_AQUA,ATTRIBUTE_WATER)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_TOKEN,nil,3,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x1f5,0x4011,1500,1500,4,RACE_AQUA,ATTRIBUTE_WATER) then
		for i=1,3 do
			local token=Duel.CreateToken(tp,m+1)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end