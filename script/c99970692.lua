--[ hololive Myth ]
local m=99970692
local cm=_G["c"..m]
function cm.initial_effect(c)

	--공수 배가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetCondition(cm.con1)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e0:SetValue(cm.defval)
	c:RegisterEffect(e0)
	
	--일반 소환
	local e2=Effect.CreateEffect(c)
	e2:SetD(m,0)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	
	--특수 소환
	local e3=MakeEff(c,"STf")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e3:SetCode(EVENT_TO_GRAVE)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	
end

--공수 배가
function cm.con1(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,8,nil)
end
function cm.atkval(e,c)
	return c:GetAttack()*2
end
function cm.defval(e,c)
	return c:GetDefense()*2
end

--일반 소환
function cm.con2(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,5,nil)
end

--특수 소환
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabelObject(re:GetHandler())
	e1:SetCondition(cm.op3con)
	e1:SetOperation(cm.op3op)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:GetHandler():RegisterFlagEffect(m,RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_OATH,2,Duel.GetTurnCount())
	else
		e:GetHandler():RegisterFlagEffect(m,RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_OATH,1)
	end
end
function cm.op3con(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetHandler():GetFlagEffectLabel(m)
	return label and label~=Duel.GetTurnCount() and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function cm.op3op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_GRAVE) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	Duel.Hint(HINT_CARD,0,m)
	if e:GetLabelObject():IsRace(RACE_DIVINE) then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	else
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.BreakEffect()
	Duel.Recover(tp,1000,REASON_EFFECT)
	e:Reset()
end
