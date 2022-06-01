--아더월드 시티
--아더월드 시티
function c76859801.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,76859801+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCost(c76859801.cost2)
	e2:SetCondition(c76859801.con2)
	e2:SetTarget(c76859801.tar2)
	e2:SetOperation(c76859801.op2)
	e2:SetCountLimit(1,76859852)
	c:RegisterEffect(e2)
	local rec=Duel.Recover
	Duel.Recover=function(tp,val,r)
		if Duel.IsPlayerAffectedByEffect(tp,76859801) then
			return 0
		else
			return rec(tp,val,r)
		end
	end
	Duel.AddCustomActivityCounter(76859801,ACTIVITY_NORMALSUMMON,c76859801.afil1)
	Duel.AddCustomActivityCounter(76859801,ACTIVITY_SPSUMMON,c76859801.afil1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(76859801)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
end
function c76859801.afil1(c)
	return c:IsSetCard(0x2cb)
end
function c76859801.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(76859801,tp,ACTIVITY_NORMALSUMMON)<1
			and Duel.GetCustomActivityCount(76859801,tp,ACTIVITY_SPSUMMON)<1
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c76859801.tar21)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)

end
function c76859801.con2(e)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<4
end
function c76859801.tar21(e,c)
	return not c:IsSetCard(0x2cb)
end
function c76859801.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=4-Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,e:GetHandler())
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c76859801.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=4-Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ct>0 then
		Duel.Draw(p,ct,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetLabel(ct)
		e1:SetLabelObject(e)
		e1:SetOperation(c76859801.op21)
		Duel.RegisterEffect(e1,tp)
		e:SetLabelObject(e1)
	end
end
function c76859801.op21(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,76859801)
	local ct=e:GetLabel()
	Duel.SetLP(tp,Duel.GetLP(tp)-ct*1000)
	local te=e:GetLabelObject()
	te:SetLabelObject(nil)
	e:Reset()
end
