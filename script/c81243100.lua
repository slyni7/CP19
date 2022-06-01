--이형의 계뢰
--카드군 번호: 0xc86
local m=81243100
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc86),2,2,nil,nil,99)

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
	
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY)
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
	
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(0x04)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(cm.co3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--회수
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,m+2)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
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

--파괴
function cm.nfil0(c)
	return c:IsFaceup() and c:IsCode(81243070)
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST)
	end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,0,0x0c,1,nil)
	end
	local ct=1
	local ops=0
	if Duel.IsExistingMatchingCard(cm.nfil0,tp,0x100,0,1,nil) then ops=ops+1 end
	if ops==1 and Duel.GetMatchingGroupCount(aux.TRUE,tp,0,0x0c,nil)>1 then ct=ct+1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,0x0c,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end

--서치
function cm.cfil0(c)
	return c:IsReleasable() and c:IsType(TYPE_XYZ)
end
function cm.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x04,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x04,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.tfil1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc86) and c:IsType(0x2+0x4)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil1,tp,0x01+0x10,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01+0x10)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tfil1),tp,0x01+0x10,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--회수
function cm.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc86) and c:IsType(0x1)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLocation(0x10) and chkc:IsControler(tp) and cm.tfil0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil0,tp,0x10,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.tfil0,tp,0x10,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
