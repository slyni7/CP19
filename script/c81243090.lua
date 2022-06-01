--이형의 계구
--카드군 번호: 0xc86
local m=81243090
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc86),4,2,nil,nil,99)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(0x40)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetOperation(cm.op1)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	
	--효과 무효
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x04)
	e2:SetCountLimit(1)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	c:RegisterEffect(e2)
	
	--replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetRange(0x04)
	e4:SetCountLimit(1,m+1)
	e4:SetValue(cm.va4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	
	--엑시즈 소재로 한다
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,m+2)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
end

--특수 소환
function cm.ncfil0(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xc86)
	and c:CheckRemoveOverlayCard(tp,2,REASON_COST)
end
function cm.cn1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.ncfil0,tp,0x04,0,nil)
	return #mg>0 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local sg=Duel.SelectMatchingCard(tp,cm.ncfil0,tp,0x04,0,1,1,nil,tp)
	if #sg==0 then
		return
	end
	sg:GetFirst():RemoveOverlayCard(tp,2,2,REASON_COST)
end

--효과 무효
function cm.nfil0(c)
	return c:IsFaceup() and c:IsCode(81243070)
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST)
	end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function cm.tfil0(c)
	return c:IsFaceup() and not c:IsDisabled() and ( c:IsType(TYPE_EFFECT) or c:IsType(0x2+0x4) )
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsOnField() and cm.tfil0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil0,tp,0,0x0c,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tfil0,tp,0,0x0c,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	if Duel.IsExistingMatchingCard(cm.nfil0,tp,0x100,0,1,nil) then
		Duel.SetChainLimit(cm.limit)
	end
end
function cm.limit(e,ep,tp)
	return tp==ep
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
end

--replace
function cm.rpfil0(c,tp)
	return c:IsFaceup() and c:IsLocation(0x04) and c:IsType(TYPE_XYZ) and c:IsControler(tp)
	and (c:IsReason(REASON_BATTLE) or ( c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp )) 
	and not c:IsReason(REASON_REPLACE)
end
function cm.va4(e,c)
	return cm.rpfil0(c,e:GetHandlerPlayer())
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return eg:IsExists(cm.rpfil0,1,c,tp)
		and c:IsAbleToGrave()
		and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		return true
	else
		return false
	end
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

--엑시즈 소재로 한다
function cm.tfil1(c)
	return c:IsFaceup() and c:IsSetCard(0xc86) and c:IsType(TYPE_XYZ)
end
function cm.mfil0(c,e)
	return c:IsCanOverlay() and c:IsSetCard(0xc86) and (not e or not c:IsImmuneToEffect(e))
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x04) and chkc:IsControler(tp) and cm.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil1,tp,0x04,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.mfil0,tp,0x10,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.tfil1,tp,0x04,0,1,1,nil)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,cm.mfil0,tp,0x10,0,1,1,nil,e)
		if #g>0 then
			Duel.Overlay(tc,g)
		end
	end
end
