--비현 - 칠성의 검
--카드군 번호: 0x1c80 0x2c80
local m=81253030
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	
	--특수 소환시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGROY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--리쿠르트
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--명칭 취급
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_CODE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(81253000)
	c:RegisterEffect(e3)
end

--특수 소환시
function cm.ctfil0(c)
	return c:IsFaceup() and c:IsSetCard(0x1c80)
end
function cm.tfil0(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local ct=Duel.GetMatchingGroup(cm.ctfil0,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGROY_DESTROY,g,#ct,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(cm.ctfil0,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0,LOCATION_MZONE,nil)
	if #g>=#ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,#ct,nil)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

--유발
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
end
function cm.spfil0(c,e,tp)
	return c:IsCode(81253000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x10) and chkc:IsControler(tp) and cm.spfil0(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfil0,tp,0x10,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfil0,tp,0x10,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end
