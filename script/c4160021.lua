--사군자의 기상
local m=4160021
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,2000)
	end
	Duel.PayLPCost(tp,2000)
end
function cm.tfil1(c,e,tp)
	return c:IsSetCard(0x4d7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tfil1(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and Duel.IsPlayerCanSpecialSummonMonster(tp,4160028,0x4d7,0x4011,0,0,2,RACE_ZOMBIE,ATTRIBUTE_DARK)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.tfil1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft-1,0,0)
	Duel.SetOperationInfo(O,CATEGORY_SPECIAL_SUMMON,g,ft,tp,LOCATION_EXTRA)
end
function cm.ofil1(c)
	return c:IsSetCard(0x4d7) and c:IsSynchroSummonable(nil)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>0	and Duel.IsPlayerCanSpecialSummonMonster(tp,4160028,0x4d7,0x4011,0,0,2,RACE_ZOMBIE,ATTRIBUTE_DARK) then
			local fid=c:GetFieldID()
			local g=Group.CreateGroup()
			for i=1,ft do
				local token=Duel.CreateToken(tp,4160028)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UNRELEASABLE_SUM)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				token:RegisterEffect(e2)
				token:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				g:AddCard(token)
			end
			Duel.SpecialSummonComplete()
			g:KeepAlive()
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetReset(RESET_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetLabel(fid)
			e3:SetLabelObject(g)
			e3:SetCondition(cm.ocon13)
			e3:SetOperation(cm.oop13)
			Duel.RegisterEffect(e3,tp)
			local sg=Duel.GetMatchingGroup(cm.ofil1,tp,LOCATION_EXTRA,0,nil)
			if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tc=sg:Select(tp,1,1,nil):GetFirst()
				Duel.SynchroSummon(tp,tc,nil)
			end
		end
	end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetTarget(cm.otar14)
	Duel.RegisterEffect(e4,tp)
end
function cm.onfil13(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.ocon13(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.onfil13,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else
		return true
	end
end
function cm.oop13(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.onfil13,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end
function cm.otar14(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end