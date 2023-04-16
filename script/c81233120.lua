--황혼의 나락
--카드군 번호: 0xc70
local m=81233120
local cm=_G["c"..m]
function cm.initial_effect(c)

	--공통 트리거
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(0x10)
	e1:SetCountLimit(1,m)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--발동
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(cm.cn3)
	c:RegisterEffect(e3)
end

--특수 소환
function cm.tfilter0(c,e,tp)
	return c:IsAbleToGrave() and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
	and Duel.IsExistingMatchingCard(cm.spfilter0,tp,0x40,0,1,nil,e,tp,c:GetCode())
end
function cm.spfilter0(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) 
	and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	and c:IsSetCard(0xc8f) and c:IsType(TYPE_SYNCHRO) and not c:IsCode(code)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(tp) and cm.tfilter0(chkc,e,tp)
	end
	if chk==0 then
		return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingTarget(cm.tfilter0,tp,0x04,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.tfilter0,tp,0x04,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then 
		return
	end
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(cm.spfilter0,tp,0x40,0,nil,e,tp,tc:GetCode())
	if #g>0 and tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc2=sg:GetFirst()
		if tc2 then
			tc2:SetMaterial(nil)
			if Duel.SpecialSummon(tc2,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
				tc2:CompleteProcedure()
			end
		end
	end
end

--패로 되돌린다
function cm.nfilter0(c)
	return c:IsFaceup() and (c:IsType(TYPE_SYNCHRO) or c:IsSetCard(0xc8f))
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.nfilter0,tp,0x04,0,1,nil)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,0x0c,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x0c)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.nfilter0,tp,0x04,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,0x0c,nil)
	if #g1==0 or #g2==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g2:Select(tp,1,#g1,nil)
	local tc=sg:GetFirst()
	while tc do
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		tc=sg:GetNext()
	end
end

function cm.nfilter1(c)
	return c:IsFaceup() and c:IsRace(RACE_WINDBEAST) and c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(8)
end
function cm.cn3(e)
	return Duel.IsExistingMatchingCard(cm.nfilter1,e:GetHandlerPlayer(),0x04,0,1,nil)
end
