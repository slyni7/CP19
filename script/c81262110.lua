--심연함귀 리코리스서희
--카드군 번호: 0xc96
local m=81262110
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:SetUniqueOnField(1,0,m)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,aux.FilterBoolFunction(cm.mfilter1),aux.FilterBoolFunction(cm.mfilter2),aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT))
	
	--소환 조건
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.va1)
	c:RegisterEffect(e1)
	
	--지속 효과
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(0x04)
	e2:SetCondition(cm.cn2)
	e2:SetValue(cm.va2)
	c:RegisterEffect(e2)
	
	--유발 효과
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(0x04)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e4:SetCountLimit(1,m+1)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCountLimit(1,m+2)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
end

--융합 소환
function cm.mfilter1(c)
	return c:IsFusionType(TYPE_FUSION) and c:IsFusionSetCard(0xc96)
end
function cm.mfilter2(c)
	return c:IsRace(RACE_FISH) and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.va1(e,se,sp,st)
	return not e:GetHandler():IsLocation(0x40) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

--효과 내성
function cm.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xc96)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSequence()>4 and Duel.IsExistingMatchingCard(cm.filter1,tp,0x04,0,1,c)
end
function cm.va2(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end

--선택 효과
function cm.filter2(c)
	return (c:IsPreviousLocation(0x0c) or c:IsPreviousLocation(0x10)) and c:IsSetCard(0xc96) and c:IsFaceup()
end
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter2,nil,1) and not eg:IsContains(e:GetHandler())
end
--묘지로 보낸다
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m)==0
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,0x0c,1,nil)
	end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x0c)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,0x0c,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
--드로우
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m)==0
		and Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
	end
end
--특수 소환
function cm.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_DARK)
	and c:IsLevelBelow(9)
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m)==0
		and Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,0x20,0,1,nil,e,tp)
	end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x20)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,0x20,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
