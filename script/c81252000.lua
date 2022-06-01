--프리즈스타의 마법사
--카드군 번호: 0xc81
local m=81252000
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	
	--스탯
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(0x04)
	e1:SetValue(cm.va1)
	c:RegisterEffect(e1)
	
	--리버스(컨트롤)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_FLIP)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--퍼미션
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(0x04)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--스탯
function cm.tfil0(c,tp)
	return c:IsFaceup() and c:GetOwner()==tp
end
function cm.va1(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x04,0,nil,1-tp)
	local ct=g:GetSum(Card.GetLevel)
	if g:IsExists(Card.IsType,1,nil,TYPE_XYZ) then
		local ct2=g:GetSum(Card.GetRank)
		ct=ct+ct2
	end
	return ct*600
end

--컨트롤
function cm.tfil1(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0 
		and Duel.IsExistingMatchingCard(cm.tfil1,tp,0,0x04,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,cm.tfil1,tp,0,0x04,1,1,nil)
	if #g>0 then
		Duel.GetControl(g,tp)
	end
end

--퍼미션
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
	and Duel.IsChainNegatable(ev)
end
function cm.tfil2(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x04) and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil2,tp,0x04,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tfil2,tp,0x04,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLocation(0x04) and Duel.NegateActivation(ev)~=0 then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
