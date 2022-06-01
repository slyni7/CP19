--인조천사 카리타스
local m=99000380
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc12),4,2)
	c:EnableReviveLimit()
	--Change race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(RACE_FAIRY)
	c:RegisterEffect(e1)
	--copy trap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetSpellSpeed(3)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON)
	e3:SetSpellSpeed(3)
	e3:SetCondition(cm.condition)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetSpellSpeed(3)
	e4:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetSpellSpeed(3)
	e5:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e5)
	--synchro summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetSpellSpeed(3)
	e6:SetTarget(cm.sctg)
	e6:SetOperation(cm.scop)
	c:RegisterEffect(e6)
end
function cm.Synthetic_Seraphim_filter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_FAIRY)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.Synthetic_Seraphim_filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) then
		return true
	else
		return e:GetHandler():GetFlagEffect(m)<1
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.filter(c)
	aux.CheckDisSumAble=true
	if not (c:CheckActivateEffect(false,true,false)~=nil) then return false end
	aux.CheckDisSumAble=false
	return c:IsType(TYPE_COUNTER) and c:IsAbleToGraveAsCost()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TRAP+TYPE_COUNTER)
		e:GetHandler():RegisterEffect(e1,true)
		local res=Duel.CheckLPCost(tp,math.min(e:GetHandler():GetAttack(),e:GetHandler():GetDefense()))
		local res2=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil)
		e1:Reset()
		return res and res2
	end
	e:SetLabel(0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_TRAP+TYPE_COUNTER)
	e:GetHandler():RegisterEffect(e1,true)
	Duel.PayLPCost(tp,math.min(e:GetHandler():GetAttack(),e:GetHandler():GetDefense()))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	aux.CheckDisSumAble=true
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	aux.CheckDisSumAble=false
	e1:Reset()
	Duel.ClearOperationInfo(0)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave() and (c:IsLevelAbove(1) or c:IsRankAbove(1))
end
function cm.level_rank(c)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	else
		return c:GetLevel()
	end
end
function cm.spfilter(c,e,tp,ct)
	local rlv=c:GetLevel()-e:GetHandler():GetRank()
	if rlv<1 then return false end
	local rg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and rg:CheckWithSumEqual(cm.level_rank,rlv,ct,63)
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=-Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		return e:GetHandler():IsAbleToGrave()
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,ct)
		and e:GetHandler():GetFlagEffect(m+10000)==0
	end
	e:GetHandler():RegisterFlagEffect(m+10000,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local ct=-Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ct)
	local tc=g:GetFirst()
	if tc then
		local rlv=tc:GetLevel()-e:GetHandler():GetRank()
		local rg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,e:GetHandler())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=rg:SelectWithSumEqual(tp,cm.level_rank,rlv,ct,63)
		g2:AddCard(e:GetHandler())
		if Duel.SendtoGrave(g2,REASON_EFFECT)~=0 then
			Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end