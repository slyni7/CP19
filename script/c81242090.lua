--견신의 사역(뿌리 왕저)
--카드군 번호: 0xc89
local m=81242090
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--코스트 대체
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(endofroots)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,m)
	c:RegisterEffect(e2)
end

--발동
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc89)
end
function cm.tfil0(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_EFFECT) and c:IsType(0x1)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingTarget(cm.spfil0,tp,0x10,0,1,nil,e,tp)
		and Duel.IsExistingTarget(cm.tfil0,tp,0,0x10,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,cm.spfil0,tp,0x10,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,cm.tfil0,tp,0,0x10,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local sg1=tg1:GetFirst()
	local sg2=tg2:GetFirst()
	if not sg1:IsRelateToEffect(e) or not sg2:IsRelateToEffect(e) then
		return false
	end
	if not sg2:IsLocation(0x10) or not sg2:IsAbleToRemove() then
		return false
	end
	if Duel.SpecialSummon(tg1,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Remove(tg2,POS_FACEUP,REASON_EFFECT)
	end
end

