--사군자 - 매화
local m=4160013
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,4160016)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tar2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetCountLimit(1,4160003)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tar3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
function cm.cfil1(c,tp)
	return c:IsCode(4160016) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil1,tp,LOCATION_ONFIELD,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	if not re then
		return false
	end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x4d7)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	if not re then
		return false
	end
	local rc=re:GetHandler()
	return r&REASON_COST>0 and rc:IsSetCard(0x4d7)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,4160023,0x4d7,0x4011,0,0,2,RACE_ZOMBIE,ATTRIBUTE_EARTH)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,4160023,0x4d7,0x4011,0,0,2,RACE_ZOMBIE,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,4160023)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.otar31)
	Duel.RegisterEffect(e1,tp)
end
function cm.otar31(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end