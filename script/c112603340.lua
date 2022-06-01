--LMo.40 Starsis(스타시스) - WNC4 [　]
local m=112603340
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddSynchroProcedure(c,cm.synfilter,aux.NonTuner(cm.synfilter2),1)
	c:SetSPSummonOnce(m)
	--summon
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(m,2))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetProperty(EFFECT_FLAG_DELAY)
	e10:SetCondition(cm.condition)
	e10:SetTarget(cm.target)
	e10:SetOperation(cm.operation)
	c:RegisterEffect(e10)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(cm.xcost)
	e3:SetOperation(cm.djop)
	c:RegisterEffect(e3)
	local e30=Effect.CreateEffect(c)
	e30:SetDescription(aux.Stringid(m,1))
	e30:SetCategory(CATEGORY_TOHAND)
	e30:SetType(EFFECT_TYPE_IGNITION)
	e30:SetRange(LOCATION_MZONE)
	e30:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e30:SetCost(cm.xcost)
	e30:SetOperation(cm.djop2)
	c:RegisterEffect(e30)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.pencon)
	e4:SetTarget(cm.pentg)
	e4:SetOperation(cm.penop)
	c:RegisterEffect(e4)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c65518099.splimit)
	c:RegisterEffect(e2)
end

cm.messier_number=40

--synchro summon
function cm.synfilter(c)
	return c:IsRace(RACE_PYRO)
end
function cm.synfilter2(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end

--summon
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.filter(c)
	return c:IsSetCard(0xe81) and c:IsSummonable(true,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end

--tohand
function cm.costfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xe97)
end
function cm.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,cm.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function cm.djop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
		local token=Duel.CreateToken(p,112700140)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-p,token)
end
function cm.djop2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
		local token=Duel.CreateToken(p,112700142)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-p,token)
end


--pendulum
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

--splimit
function cm.splimit(e,c,tp,sumtp,sumpos)
	return not (c:IsSetCard(0xe97) or c:IsSetCard(0xe81))
end