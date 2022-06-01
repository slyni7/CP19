--[ Ironclad ]
local m=99970797
local cm=_G["c"..m]
function cm.initial_effect(c)

	YuL.Activate(c)

	--수비력 증가
	local e0=MakeEff(c,"F","F")
	e0:SetCode(EFFECT_UPDATE_DEFENSE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xad6d))
	e0:SetValue(1000)
	c:RegisterEffect(e0)
	
	--서치 + 특수 소환
	local e1=MakeEff(c,"I","F")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,m)
	e1:SetCost(YuL.discard(1,1))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--무효화
	local e2=MakeEff(c,"F","F")
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetCondition(cm.con2)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)
	
end

--서치 + 특수 소환
function cm.tar1fil(c)
	return c:IsSetCard(0xad6d) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar1fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op1fil(c,e,tp)
	return c:IsSetCard(0xad6d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tar1fil,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local tg=Duel.GetMatchingGroup(cm.op1fil,tp,LOCATION_HAND,0,nil,e,tp)
	if #tg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=tg:Select(tp,1,1,nil)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--무효화
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:GetSum(Card.GetDefense)>=Duel.GetLP(1-tp)*2
end
