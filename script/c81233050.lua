--황혼의 축복
--카드군 번호: 0xc70
local m=81233050
local cm=_G["c"..m]
function cm.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	--공통 트리거
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(0x10)
	e1:SetCountLimit(1,m)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--파괴 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(0x08)
	e2:SetTargetRange(0x04,0)
	e2:SetTarget(cm.tg2)
	e2:SetValue(cm.va2)
	c:RegisterEffect(e2)
	
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(0x08)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end

--특수 소환
function cm.tfilter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and ( c:IsType(TYPE_SYNCHRO) or c:IsSetCard(0xc8f) )
	and Duel.IsExistingMatchingCard(cm.spfilter1,tp,0x01+0x02,0,1,nil,lv,e,tp)
end
function cm.spfilter1(c,lv,e,tp)
	return c:GetLevel()>0 and c:GetLevel()<lv and c:IsSetCard(0xc8f)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x04) and chkc:IsControler(tp) and cm.tfilter1(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingTarget(cm.tfilter1,tp,0x04,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.tfilter1,tp,0x04,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01+0x02)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,0x04)<=0 then
		return
	end
	local lv=tc:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,0x01+0x02,0,1,1,nil,lv,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--파괴 내성
function cm.tg2(e,c)
	return c:IsSetCard(0xc8f)
end
function cm.va2(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else
		return 0
	end
end

--서치
function cm.nfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc8f) and c:IsControler(tp)
end
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=m
	local tc=eg:GetFirst()
	if tc:IsSummonType(SUMMON_TYPE_NORMAL) then
		val=val+1
	else
		val=val+2
	end
	return eg:IsExists(cm.nfilter1,1,nil,tp) and c:GetFlagEffect(val)==0
end
function cm.filter1(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0xc8f) and c:IsLocation(0x04)
end
function cm.tfilter2(c,lv)
	return c:GetLevel()>0 and c:GetLevel()<lv and c:IsSetCard(0xc8f) and c:IsAbleToHand()
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.filter1,nil,tp)
	local tg=g:GetMaxGroup(Card.GetLevel)
	local tc=tg:GetFirst()
	if chk==0 then
		return tc:GetControler()==tp
		and Duel.IsExistingMatchingCard(cm.tfilter2,tp,0x01,0,1,nil,tc:GetLevel())
	end
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
	local val=m
	if tc:IsSummonType(SUMMON_TYPE_NORMAL) then
		val=val+1
	else
		val=val+2
	end
	e:GetHandler():RegisterFlagEffect(val,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetMaxGroup(Card.GetLevel)
	local tc=tg:GetFirst()
	if not e:GetHandler():IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local mg=Duel.SelectMatchingCard(tp,cm.tfilter2,tp,0x01,0,1,1,nil,tc:GetLevel())
	if #mg>0 then
		Duel.SendtoHand(mg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,mg)
	end
end
