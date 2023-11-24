--[ Star Absorber ]
local s,id=GetID()
function s.initial_effect(c)

	local ea=Effect.CreateEffect(c)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ea:SetCode(EVENT_PREDRAW)
	ea:SetRange(LOCATION_DECK)
	ea:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	ea:SetCondition(function(_,tp) return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=36 end)
	ea:SetOperation(s.startop)
	c:RegisterEffect(ea)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd36))
	e3:SetValue(function(e,c) return Duel.GetCounter(0,1,1,0x1051)*1 end)
	c:RegisterEffect(e3)
	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.rmcon)
	e5:SetOperation(s.rmop)
	c:RegisterEffect(e5)
	
	local e9=MakeEff(c,"SC","F")
	e9:SetCode(EFFECT_SEND_REPLACE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	WriteEff(e9,9,"TO")
	c:RegisterEffect(e9)

end

function s.startop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
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

function s.filterrm(c,e,tp,ct)
	return c:IsSetCard(0xd36) and c:IsLevelBelow(ct) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=math.floor(c:GetCounter(0x1051)/2)
	if ct>0 then
		c:RemoveCounter(tp,0x1051,ct,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(s.filterrm,tp,LOCATION_DECK,0,nil,e,tp,ct)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function s.tar9(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE+REASON_RULE) or e:GetHandler():GetReasonPlayer()~=1-tp
		and e:GetHandler():GetCounter(0x1051)>6 end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.op9(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x1051,7,REASON_EFFECT)
end
