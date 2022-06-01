--기연자의 장
--카드군 번호: 0xcba
local m=81232010
local cm=_G["c"..m]
function cm.initial_effect(c)

	--세트
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(0x02)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(cm.cn2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--유발 효과
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--특수 소환
function cm.mfilter1(c,ft)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x1cba)
	and ( (c:IsFaceup() and c:IsLocation(0x04) or (c:IsFacedown() and c:IsLocation(0x08))) )
	and (ft>0 or c:GetSequence()<5)
end
function cm.cn2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,0x04)
	local loc=0x04+0x08
	if ft==0 then loc=0x04 end
	return ft>-1 and Duel.IsExistingMatchingCard(cm.mfilter1,tp,loc,0,1,nil,ft)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,0x04)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.mfilter1,tp,0x04+0x08,0,1,1,nil,ft)
	Duel.SendtoGrave(g,REASON_COST)
end

--덱으로 되돌린다
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(0x08)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return true
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,0x0c+0x10,1,nil)
	end
	local b1=Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,0x0c,1,nil)
	local b2=Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,0x10,1,nil)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	else
		op=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=nil
	if op==0 then
		g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,0x0c,1,1,nil)
	elseif op==1 then
		g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,0x10,1,1,nil)
	else
		g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,0x0c+0x10,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function cm.filchk(c)
	return c:IsFaceup() and c:IsCode(81232080)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		if Duel.IsExistingMatchingCard(cm.filchk,tp,0x0c+0x10,0,1,nil) then
			Duel.Damage(1-tp,800,REASON_EFFECT)
		end
	end
end
