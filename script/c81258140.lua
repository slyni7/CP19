--노스 유니온의 기백
--카드군 번호: 0xc99
local m=81258140
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--필드에서 벗어났을 때에 묘지로 보낸다
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(cm.op2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(cm.op3)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	
	--엑스트라 덱에서 특수 소환할 수 없다
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetRange(0x08)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.tg4)
	c:RegisterEffect(e4)
	
	--묘지로 보낸다
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(0x10)
	e5:SetCost(cm.co5)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
end

--특수 소환
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc99)
end
function cm.filter0(c)
	return c:IsFaceup() and c:IsSetCard(0xc9a)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x10) and chkc:IsControler(tp) and cm.spfil0(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingTarget(cm.spfil0,tp,0x10,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfil0,tp,0x10,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	if Duel.IsExistingMatchingCard(cm.filter0,tp,0x08,0,1,nil) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(cm.ova1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function cm.ova1(e,c)
	return e:GetOwner()==c
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then
		return
	end
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(0x04) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

--엑스트라 덱에서 특수 소환할 수 없다
function cm.tg4(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(0x40) and not c:IsSetCard(0xc99)
end

--묘지로 보낸다
function cm.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc9a)
end
function cm.co5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(cm.cfil0,tp,0x10,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x10,0,1,1,nil)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,0x0c,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,0x0c,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

		