--Star Absorber
function c99970077.initial_effect(c)

	--발동
	local ea=Effect.CreateEffect(c)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ea:SetCode(EVENT_PREDRAW)
	ea:SetRange(LOCATION_DECK)
	ea:SetCountLimit(1,99970077,EFFECT_COUNT_CODE_DUEL)
	ea:SetOperation(c99970077.stop)
	c:RegisterEffect(ea)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	--소환 제약
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99970077.splimit)
	c:RegisterEffect(e2)
	
	--카운터
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970077,0))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(c99970077.ctop)
	c:RegisterEffect(e1)

	--레벨 증가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c99970077.star_tg)
	e3:SetValue(c99970077.star_up)
	c:RegisterEffect(e3)
	
	--카운터 제거
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c99970077.rmcon)
	e5:SetOperation(c99970077.rmop)
	c:RegisterEffect(e5)
	
end

--발동
function c99970077.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	end
end

--소환 제약
function c99970077.splimit(e,c)
	return not c:IsSetCard(0xd36)
end

--카운터
function c99970077.ctop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   local tc=eg:GetFirst()
   while tc do
      if tc:GetOriginalLevel()>0 then
         c:AddCounter(0x1051,tc:GetOriginalLevel())
      elseif tc:GetOriginalRank()>0 then
         c:AddCounter(0x1051,tc:GetOriginalRank())
      end
      tc=eg:GetNext()
   end
end

--레벨 증가
function c99970077.star_tg(e,c)
	return c:IsSetCard(0xd36)
end
function c99970077.star_up(e,c)
	return Duel.GetCounter(0,1,1,0x1051)*1
end

--카운터 제거
function c99970077.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c99970077.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1051)
	if ct>1 then
		c:RemoveCounter(tp,0x1051,math.floor(ct/2),REASON_EFFECT)
	end
end

