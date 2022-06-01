--심연함 공모서희
--카드군 번호: 0xc96
local m=81262040
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunction(cm.mat1),aux.FilterBoolFunction(cm.mat2))
	
	--회피
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.tg1)
	e1:SetValue(cm.val1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e2)
end

--소재
function cm.mat1(c)
	return c:IsType(0x1) and c:IsSetCard(0xc96)
end
function cm.mat2(c)
	return c:IsLevelBelow(5) or (c:IsRace(RACE_FISH) and c:IsAttribute(ATTRIBUTE_DARK))
end

--회피
function cm.rpfil0(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xc96) and c:IsControler(tp)
	and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.val1(e,c)
	return cm.rpfil0(c,e:GetHandlerPlayer())
end
function cm.tfil0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xc96)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return eg:IsExists(cm.rpfil0,1,nil,tp)
		and Duel.IsExistingMatchingCard(cm.tfil0,tp,0x02,0,1,nil)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		return true
	else
		return false
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x02,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
end

--서치
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.tfil0(c,e,tp,ft)
	return c:IsSetCard(0xc96) and c:IsType(0x1) 
	and (c:IsAbleToHand() or ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil,e,tp,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
