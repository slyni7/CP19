--구마의 때(뿌리 왕저)
--카드군 번호: 0xc89
local m=81242070
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동(의식 소환)
	local e1=hebi.AddRitualProcGreater2ExLoc(c,aux.FilterBoolFunction(Card.IsSetCard,0xc89),0x02+0x10,cm.mfil0(c))
	e1:SetDescription(aux.Stringid(m,0))
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(0x02)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--회수
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(0x10)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(cm.co3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--상대 묘지만을 참조한다
function cm.mfil0(lc)
	return 
		function(c)
			local te=lc:GetActivateEffect()
			local tp=te:GetHandlerPlayer()
			return c:IsControler(1-tp) and c:IsLocation(0x10)
		end
end

--코스트
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
		and Duel.CheckReleaseGroup(tp,nil,1,nil)
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.spfil0(c,e,tp,ft)
	return c:IsSetCard(0xc89) and c:IsType(TYPE_RITUAL) and c:IsType(0x1)
	and ( c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)))
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,0x04)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.spfil0,tp,0x01+0x10,0,1,nil,e,tp,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,0x01+0x10)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,0x01+0x10)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,0x04)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfil0),tp,0x01+0x10,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,true,false) or ft<=0 or Duel.SelectYesNo(tp,aux.Stringid(m,4))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end

--회수
function cm.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0x02+0x04,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,0x02+0x04,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.ofil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc89) and c:IsType(0x1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,c)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.ofil0),tp,0x10+0x20,0,nil)
		if #g>0 and Duel.GetFieldGroupCount(tp,0x04,0)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
