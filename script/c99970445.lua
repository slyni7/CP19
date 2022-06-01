--스타 앱소버: 파형의 별
local m=99970445
local cm=_G["c"..m]
function cm.initial_effect(c)

	--스타 앱소버 공격력
	local es=Effect.CreateEffect(c)
	es:SetType(EFFECT_TYPE_SINGLE)
	es:SetCode(EFFECT_UPDATE_ATTACK)
	es:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	es:SetRange(LOCATION_MZONE)
	es:SetValue(cm.starabsorber)
	c:RegisterEffect(es)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--효과 내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.immcon)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,99970077))
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	
end

--스타 앱소버 공격력
function cm.starabsorber(e,c)
	return c:GetLevel()*100
end

--특수 소환
function cm.filter(c)
	return c:IsSetCard(0xd36) and c:IsAbleToHand()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1051,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1051,4,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,0,nil)
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if c:GetLevel()>=10 and g:GetCount()>0
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

--효과 내성 부여
function cm.immcon(e)
	return e:GetHandler():GetLevel()~=e:GetHandler():GetOriginalLevel()
end
function cm.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
