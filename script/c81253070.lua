--비의 - 배반의 후방사격(비현)
--카드군 번호: 0x1c80 0x2c80
local m=81253070
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--상대 턴에도
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(cm.cn2)
	c:RegisterEffect(e2)
	
	--샐비지
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(0x10)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--발동시
function cm.nfil0(c)
	return c:IsFaceup() and c:IsCode(81253000)
end
function cm.cn2(e)
	local tp=e:GetHandler():GetControler()
	local ct=Duel.GetMatchingGroupCount(cm.nfil0,tp,0x0c,0x0c,nil)
	return ct>0
end
function cm.cfil0(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x1c80)
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x01,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x01,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tfil0(c,tp)
	return c:GetOwner()==tp
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil0,tp,0,LOCATION_MZONE,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.tfil0,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x0c)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFirstTarget()
	local p=c:GetControler()
	local seq=c:GetSequence()
	local g=Group.CreateGroup()
	local tc=Duel.GetFieldCard(p,LOCATION_MZONE,seq)
	if tc then
		g:AddCard(tc)
	end
	if seq>0 then
		tc=Duel.GetFieldCard(p,LOCATION_MZONE,seq-1)
		if tc then
			g:AddCard(tc)
		end
	end
	if seq<4 then
		tc=Duel.GetFieldCard(p,LOCATION_MZONE,seq+1)
		if tc then
			g:AddCard(tc)
		end
	end
	local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,p)
	if c:IsRelateToEffect(e) and Duel.Destroy(g,REASON_EFFECT)~=0 and #cg>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(cg,REASON_EFFECT)
	end
end

--샐비지
function cm.nfil1(c,tp)
	return c:GetOwner()==tp and c:IsControler(1-tp)
end
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil1,1,nil,tp)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsSSetable()
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(0x20)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1)
	end
end
