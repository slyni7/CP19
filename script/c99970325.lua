--[KATANAGATARI]
local m=99970325
local cm=_G["c"..m]
function cm.initial_effect(c)

	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,nil,aux.FilterBoolFunction(Card.IsModuleCode,99970317),1,1,nil)

	--악도칠실
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)

	--축복받은 천재
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)

	--견계고
	local e3=MakeEff(c,"FTo","M")
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetProperty(spinel.delay)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
	
	--저주받은 신체
	local e4=MakeEff(c,"FTf","M")
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	WriteEff(e4,4,"O")
	c:RegisterEffect(e4)

end

--악도칠실
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_MODULE)
end
function cm.eqfil(c,ec)
	return c:IsCode(99970317) and c:CheckEquipTarget(ec)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.eqfil,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.eqfil,tp,LOCATION_GRAVE,0,1,1,nil,c)
	if g:GetCount()>0 then
		Duel.Equip(tp,g:GetFirst(),c)
	end
end

--견계고
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and tc
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if tc and c:IsRelateToBattle(e) and c:IsFaceup() and tc:IsFaceup() and tc:IsRelateToBattle(e) then
		local atk=c:GetBaseAttack()+tc:GetAttack()
		local def=c:GetBaseDefense()+tc:GetDefense()
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(atk)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_SET_BASE_DEFENSE)
		e3:SetValue(def)
		c:RegisterEffect(e3)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end

--저주받은 신체
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-1400)
		Duel.Destroy(c,REASON_EFFECT)
	end
end
