--파요괴승(뿌리 왕저)
--카드군 번호: 0xc89
local m=81242140
local cm=_G["c"..m]
function cm.initial_effect(c)

	--메인 공통
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_RELEASE)
	e1:SetRange(0x10)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetCost(hebi.rootscost)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(0x02)
	e2:SetCondition(cm.cn2)
	e2:SetCost(hebi.rootscost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end

--샐비지
function cm.nfil0(c)
	return c:IsSetCard(0xc89) and c:IsType(0x1) and not c:IsPreviousLocation(0x08)
end
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil0,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand() 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02)
end
function cm.ofil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc89)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(cm.ofil0,tp,0x02,0,nil,e,tp)
		if #g>0 and Duel.GetLocationCount(tp,0x04)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc then
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetValue(0x20)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1,true)
			end
			Duel.SpecialSummonComplete()
		end
	end
end

--특수 소환
function cm.nfil0(c)
	return c:IsFaceup() and c:IsSetCard(0xc89)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.nfil0,tp,0x04,0,1,nil)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,0x04)<=0 or not c:IsRelateToEffect(e) then
		return
	end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

--서치
function cm.tfil0(c)
	return c:IsAbleToHand() and c:IsCode(81242070)
end
function cm.exfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc89) and c:IsType(0x2+0x4)
end
function cm.tfil1(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local tar_filter=0
	if Duel.IsExistingMatchingCard(cm.tfil1,tp,0x04,0,1,nil) then
		tar_filter=cm.exfil0
	else
		tar_filter=cm.tfil0
	end
	if chk==0 then
		return Duel.IsExistingMatchingCard(tar_filter,tp,0x01+0x10,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x1+0x10)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tar_filter=0
	if Duel.IsExistingMatchingCard(cm.tfil1,tp,0x04,0,1,nil) then
		tar_filter=cm.exfil0
	else
		tar_filter=cm.tfil0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(tar_filter),tp,0x01+0x10,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end