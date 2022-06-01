--감정의 돌
local m=99000328
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.retcon)
	e2:SetTarget(cm.rettg)
	e2:SetOperation(cm.retop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(cm.checkop)
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local check_att=0
	if Duel.GetFlagEffect(tp,99000328+1)~=0 then check_att=check_att+ATTRIBUTE_EARTH end
	if Duel.GetFlagEffect(tp,99000328+2)~=0 then check_att=check_att+ATTRIBUTE_WATER end
	if Duel.GetFlagEffect(tp,99000328+3)~=0 then check_att=check_att+ATTRIBUTE_FIRE end
	if Duel.GetFlagEffect(tp,99000328+4)~=0 then check_att=check_att+ATTRIBUTE_WIND end
	if Duel.GetFlagEffect(tp,99000328+5)~=0 then check_att=check_att+ATTRIBUTE_LIGHT end
	if Duel.GetFlagEffect(tp,99000328+6)~=0 then check_att=check_att+ATTRIBUTE_DARK end
	if Duel.GetFlagEffect(tp,99000328+7)~=0 then check_att=check_att+ATTRIBUTE_DIVINE end
	if chk==0 then return 0xff-check_att>128 and Duel.CheckLPCost(tp,1000) and Duel.CheckLPCost(1-tp,1000) end
	Duel.PayLPCost(tp,1000)
	Duel.PayLPCost(1-tp,1000)
	Duel.RegisterFlagEffect(tp,99000328+99000398,RESET_PHASE+PHASE_END,0,1)
end
function cm.tgfilter(c)
	return (c:IsSetCard(0xc15) or c:IsCode(54360049)) and c:IsAbleToGrave()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check_att=0
	if Duel.GetFlagEffect(tp,99000328+1)~=0 then check_att=check_att+ATTRIBUTE_EARTH end
	if Duel.GetFlagEffect(tp,99000328+2)~=0 then check_att=check_att+ATTRIBUTE_WATER end
	if Duel.GetFlagEffect(tp,99000328+3)~=0 then check_att=check_att+ATTRIBUTE_FIRE end
	if Duel.GetFlagEffect(tp,99000328+4)~=0 then check_att=check_att+ATTRIBUTE_WIND end
	if Duel.GetFlagEffect(tp,99000328+5)~=0 then check_att=check_att+ATTRIBUTE_LIGHT end
	if Duel.GetFlagEffect(tp,99000328+6)~=0 then check_att=check_att+ATTRIBUTE_DARK end
	if Duel.GetFlagEffect(tp,99000328+7)~=0 then check_att=check_att+ATTRIBUTE_DIVINE end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,0xff-check_att)
	if att==ATTRIBUTE_EARTH then check=1 end
	if att==ATTRIBUTE_WATER then check=2 end
	if att==ATTRIBUTE_FIRE then check=3 end
	if att==ATTRIBUTE_WIND then check=4 end
	if att==ATTRIBUTE_LIGHT then check=5 end
	if att==ATTRIBUTE_DARK then check=6 end
	if att==ATTRIBUTE_DIVINE then check=7 end
	if Duel.GetFlagEffect(tp,99000328+check)==0 then
		--lpcost
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PAY_LPCOST)
		e1:SetCondition(cm.lpcon)
		e1:SetOperation(cm.lpop)
		e1:SetLabel(att)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,99000328+check,nil,0,1)
	end
	if Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then	
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
end
function cm.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetAttribute()==e:GetLabel()
end
function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
	if ev>=2001 then ev=2000 end
	Duel.PayLPCost(1-ep,ev)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_LEAVE_CONFIRMED) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end