--[The Shard of Dream]
local m=99970547
local cm=_G["c"..m]
function cm.initial_effect(c)

	--싱크로
	RevLim(c)
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.NonTuner(nil),1,99,aux.ProcFitSquare(cm))

	--●파괴 ●대상 내성
	local e1=MakeEff(c,"STo")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(spinel.delay)
	WriteEff(e1,1,"TO")
	e1:SetCondition(spinel.stypecon(SUMMON_TYPE_SYNCHRO))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	e2:SetCondition(spinel.stypecon(SUMMON_TYPE_SYNCHRO))
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_MATERIAL)
	WriteEff(e0,0,"NO")
	c:RegisterEffect(e0)
	
	--소환 무효
	local e3=MakeEff(c,"Qo","M")
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetCode(EVENT_SUMMON)
	e3:SetCL(1,YuL.S)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	
end

--스퀘어
cm.square_mana={ATTRIBUTE_WATER,ATTRIBUTE_WATER,ATTRIBUTE_WATER,ATTRIBUTE_WATER,ATTRIBUTE_WATER,ATTRIBUTE_WATER,0x0,0x0}
cm.custom_type=CUSTOMTYPE_SQUARE

--●파괴 ●대상 내성
function cm.filter(c)
	return not c:IsHasSquareMana(ATTRIBUTE_WATER) or c:IsFacedown()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.con0(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO or r==REASON_SQUARE
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=MakeEff(rc,"STo")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(spinel.delay)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	rc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(rc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	rc:RegisterEffect(e2,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_TYPE)
		e0:SetValue(TYPE_EFFECT)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		rc:RegisterEffect(e0,true)
	end
end

--소환 무효
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsHasSquareMana(ATTRIBUTE_WATER)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
