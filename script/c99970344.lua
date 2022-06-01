--Orcatia West
local m=99970344
local cm=_G["c"..m]
function cm.initial_effect(c)

	--유니온
		--●장착
		local e01=Effect.CreateEffect(c)
		e01:SetDescription(aux.Stringid(m,0))
		e01:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e01:SetCategory(CATEGORY_EQUIP)
		e01:SetType(EFFECT_TYPE_IGNITION)
		e01:SetRange(LOCATION_MZONE)
		e01:SetTarget(cm.union_eqtg)
		e01:SetOperation(cm.union_eqop)
		c:RegisterEffect(e01)
		--●장착 해제
		local e02=Effect.CreateEffect(c)
		e02:SetDescription(aux.Stringid(m,1))
		e02:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e02:SetType(EFFECT_TYPE_IGNITION)
		e02:SetRange(LOCATION_SZONE)
		e02:SetTarget(cm.union_sptg)
		e02:SetOperation(cm.union_spop)
		c:RegisterEffect(e02)
		--●파괴 대체
		local e03=Effect.CreateEffect(c)
		e03:SetType(EFFECT_TYPE_EQUIP+EFFECT_TYPE_CONTINUOUS)
		e03:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e03:SetCode(EFFECT_DESTROY_REPLACE)
		e03:SetTarget(cm.union_reptg)
		e03:SetOperation(cm.union_repop)
		c:RegisterEffect(e03)
		--●장착 조건
		local e04=Effect.CreateEffect(c)
		e04:SetType(EFFECT_TYPE_SINGLE)
		e04:SetCode(EFFECT_EQUIP_LIMIT)
		e04:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e04:SetValue(cm.union_eqlimit)
		c:RegisterEffect(e04)
	
	--속성 추가
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_EQUIP)
	e00:SetCode(EFFECT_ADD_ATTRIBUTE)
	e00:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e00)
	
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_SZONE)
	WriteEff(e2,2,"N")
	c:RegisterEffect(e2)
	
end

--유니온
function cm.union_eqfil(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and ct2==0
end
function cm.union_eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.union_eqfil(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.union_eqfil,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.union_eqfil,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.union_eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not cm.union_eqfil(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function cm.union_sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.union_spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		c:RegisterEffect(e1)
	end
end
function cm.union_reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.union_repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function cm.union_eqlimit(e,c)
	return c:IsRace(RACE_PLANT) or e:GetHandler():GetEquipTarget()==c
end

--특수 소환
function cm.con1(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg:GetCount()>0
end
function cm.con2(e)
	local tc=e:GetHandler():GetEquipTarget()
	return tc~=nil
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0xe10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ec=e:GetHandler():GetEquipTarget()
	if ec and not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			Duel.SpecialSummonComplete()
		end
	end
end
