--귀걸 팔천의 은혜
--카드군 번호: 0xc87
local m=81245080
local cm=_G["c"..m]
function cm.initial_effect(c)

	--공격 대상 제한
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(0x04)
	e1:SetTargetRange(0,0x04)
	e1:SetValue(cm.va1)
	c:RegisterEffect(e1)
	
	--데미지
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	--카피
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(0x10)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.cn4)
	e4:SetCost(cm.co4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end

--공격 대상 제한
function cm.va1(e,c)
	return c:IsFaceup() and c:IsSetCard(0xc87) and c~=e:GetHandler()
end

--데미지 및 공격력 상승
function cm.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xc87)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.filter1,tp,0x10,0,1,nil)
	end
	local g=Duel.GetMatchingGroup(cm.filter1,tp,0x10,0,nil)
	local dam=g:GetClassCount(Card.GetCode)*200
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter1,tp,0x10,0,nil)
	local dam=g:GetClassCount(Card.GetCode)*200
	Duel.Damage(1-tp,dam,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(dam)
		e1:SetReset(RESET_EVENT+RESET_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end

--카피
function cm.cn4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetTurnID()==Duel.GetTurnCount() and not c:IsReason(REASON_RETURN)
end
function cm.cfilter1(c,exc,e,tp,eg,ep,ev,re,r,rp)
	local te=c:CheckActivateEffect(true,true,false)
	if not ( c:IsSetCard(0xc87) and c:IsType(0x2+0x4) and c:IsAbleToRemoveAsCost() and te and te:GetOperation() ) then
		return false
	end
	local tg=te:GetTarget()
	return (not tg) or tg(e,tp,eg,ep,ev,re,r,rp,0,nil,exc)
end
function cm.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(cm.cfilter1,tp,0x10,0,1,nil,c,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,0x10,0,1,1,nil,c,e,tp,eg,ep,ev,re,r,rp)
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if chkc then
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc,c)
	end
	if chk==0 then
		return true
	end
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
end
