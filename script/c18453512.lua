--SSSS.PY MISSION-강습
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	--e2:SetCountLimit(1)
	e2:SetCondition(s.drcon)
	e2:SetCost(s.cost)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
s.listed_series={0x22f2}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(id)==0
	end
	c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.descon)
	e1:SetOperation(s.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,3)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	if des:IsReason(REASON_BATTLE) then
		local rc=des:GetReasonCard()
		return rc and rc:IsSetCard(0x22f2) and rc:IsControler(tp) and rc:IsRelateToBattle()
	elseif re then
		local rc=re:GetHandler()
		return eg:IsExists(s.cfilter,1,nil,tp)
			and rc and rc:IsSetCard(0x22f2) and rc:IsControler(tp) and re:IsActiveType(TYPE_MONSTER)
	end
	return false
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ocode=c:GetOriginalCode()
	if ocode==SSSSGridmanCodes[id] and Duel.SelectEffectYesNo(tp,c,aux.Stringid(18453493,4)) then
		c:ResetFlagEffect(id)
		Duel.RegisterFlagEffect(ocode,RESET_PHASE+PHASE_END,0,1)
		local mt=_G["c"..ocode]
		local te=mt.eff_ct[c][1]
		local op=te:GetOperation()
		op(e,tp,eg,ep,ev,re,r,rp)
		return
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x22f2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
