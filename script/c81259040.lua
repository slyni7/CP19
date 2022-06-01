--뱀피어스로네 루나쿠스
--카드군 번호: 0xc98
function c81259040.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc98),aux.NonTuner(nil),1,63)
	
	--공통
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,81259040)
	e2:SetCondition(c81259040.cn2)
	e2:SetCost(c81259040.co2)
	e2:SetTarget(c81259040.tg2)
	e2:SetOperation(c81259040.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetCondition(c81259040.cn3)
	c:RegisterEffect(e3)
	
	--프리체인
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_MAIN_END)
	e4:SetCountLimit(1)
	e4:SetCost(c81259040.co4)
	e4:SetTarget(c81259040.tg4)
	e4:SetOperation(c81259040.op4)
	c:RegisterEffect(e4)
end

--공통
function c81259040.cn2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsControler(tp) and tc:IsSetCard(0xc98)
end
function c81259040.cn3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c81259040.cfil0(c)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0xc98)
end
function c81259040.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81259040.cfil0,tp,0x10,0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c81259040.cfil0,tp,0x10,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_RETURN)
end
function c81259040.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetChainLimit(c81259040.chlim)
end
function c81259040.chlim(e,rp,tp)
	local c=e:GetHandler()
	return tp==rp or (not c:IsType(TYPE_SPELL+TYPE_TRAP) )
end
function c81259040.ofil0(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c81259040.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local dg=Duel.GetMatchingGroup(c81259040.ofil0,tp,0,0x0c,nil)
		if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(81259040,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end

--프리체인
function c81259040.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,100)
	end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,500)/100)
	local t={}
	for i=1,m do
		t[i]=i*100
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(ac)
end
function c81259040.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetChainLimit(c81259040.chlim)
end
function c81259040.op4(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c81259040.o4tg1)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function c81259040.o4tg1(e,c)
	return c:IsFaceup() and c:IsSetCard(0xc98)
end
