--[KATANAGATARI]
local m=99970322
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c)

	--칼의 독
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD)
	e0:SetOperation(cm.katana)
	c:RegisterEffect(e0)

	--가장 유리한 칼
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(cm.adcon)
	e2:SetTarget(cm.adtg)
	e2:SetValue(-1000)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)

	--단죄염도
	local e4=MakeEff(c,"Qo","S")
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.tar4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	
	
end

--칼의 독
function cm.katana(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetEquipTarget()
	if tc and e:GetHandler():IsReason(REASON_EFFECT) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

--가장 유리한 칼
function cm.adcon(e)
	if Duel.GetCurrentPhase()~=PHASE_DAMAGE_CAL then return false end
	local d=Duel.GetAttackTarget()
	if not d then return false end
	local tp=e:GetHandlerPlayer()
	if d:IsControler(1-tp) then d=Duel.GetAttacker() end
	return e:GetHandler():GetEquipTarget()==d
end
function cm.adtg(e,c)
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end

--단죄염도
function cm.filter(c,g)
	return g:IsContains(c)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cg=e:GetHandler():GetEquipTarget():GetColumnGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.filter(chkc,cg) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,1,nil,cg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
