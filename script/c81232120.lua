--기연자 나이트체이서
--카드군 번호: 0xcba
local m=81232120
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
	aux.EnableChangeCode(c,81232000,0x04+0x10)
	
	--특수 소환
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,1))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(0x40)
	e0:SetCondition(cm.cn0)
	e0:SetOperation(cm.op0)
	e0:SetValue(SUMMON_TYPE_ORDER)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.va1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(0x40)
	e2:SetCondition(cm.cn2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--소환 유발
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--기동 효과
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e4:SetRange(0x10)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCondition(cm.cn5)
	c:RegisterEffect(e5)
end
cm.CardType_Order=true

function cm.va1(e,se,sp,st)
	return not e:GetHandler():IsLocation(0x40) or aux.ordlimit(e,se,sp,st)
end
function cm.mfilter0(c)
	return c:IsSetCard(0x1cba) and c:IsLevelBelow(6)
end
function cm.mfilter1(c)
	return c:IsSetCard(0x1cba) and c:IsFacedown()
end

--오더 소환
function cm.cn0(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.mfilter0,tp,0x04,0,1,nil,tp,c)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.mfilter0,tp,0x04,0,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_ORDER+REASON_MATERIAL)
end

--특수 소환
function cm.cn2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,0x04)
	if ft<=0 then
		loc=0x04
	else
		loc=0x0c
	end
	return Duel.IsExistingMatchingCard(cm.mfilter1,tp,loc,0,1,nil,tp,c)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,0x04)
	if ft<=0 then
		loc=0x04
	else
		loc=0x0c
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.mfilter1,tp,loc,0,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end

--덱 확인
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDiscardDeck(tp,3)
	end
end
function cm.filter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcba)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then
		return
	end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if #g>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(cm.filter0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,cm.filter0,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end

--특수 소환
function cm.nfilter0(c)
	return c:IsFaceup() and c:IsCode(81232080)
end
function cm.cn5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.nfilter0,tp,0x0c+0x10,0,1,nil)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=0
	local ft=Duel.GetLocationCount(tp,0x04)
	if ft<=0 then
		loc=0x04
	else
		loc=0x0c
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFacedown,tp,loc,0,1,nil)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,loc,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then
		return
	end
	Duel.SendtoGrave(tc,REASON_EFFECT)
	if Duel.GetLocationCount(tp,0x04)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
