--사악종-크리티
--카드군 번호: 0xc83
local m=81249010
local cm=_G["c"..m]
function cm.initial_effect(c)

	aux.EnableDualAttribute(c)
	--듀얼 활성시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x04)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.cn1)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)

	--제외되어 있을 경우
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x20)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--특수 소환
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsDualState(e)
end
function cm.cfil0(c,e,tp)
	return c:IsAbleToGraveAsCost()
	and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x01,0,1,nil,e,tp,c:GetCode())
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x02,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x02,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetCode())
	Duel.SendtoGrave(tc,REASON_COST)
end
function cm.spfil0(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc83) and not c:IsCode(code)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
end
function cm.ofil0(c)
	return c:IsSSetable(ignore) and c:IsSetCard(0xc83) and c:IsType(0x2+0x4)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x01,0,1,1,nil,e,tp,e:GetLabel())
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g2=Duel.GetMatchingGroup(cm.ofil0,tp,0x01+0x10,0,nil)
		if #g2>0 and Duel.GetLocationCount(tp,0x08)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g2:Select(tp,1,1,nil)
			Duel.SSet(tp,sg:GetFirst())
		end
	end
end

--프리체인
function cm.cfil1(c)
	return c:IsFaceup() and c:IsSetCard(0xc83)
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsFaceup()
		and Duel.IsExistingMatchingCard(cm.cfil1,tp,0x20,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil1,tp,0x20,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return true
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,0,0x04,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,0x04,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
		