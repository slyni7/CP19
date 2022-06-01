--[ Juuki ]
local m=99970733
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	
	--효과 파괴 내성
	YuL.ind_eff(c,LOCATION_MZONE,0)
	
	--세트
	local e5=MakeEff(c,"STo")
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCL(1,m)
	WriteEff(e5,5,"NTO")
	c:RegisterEffect(e5)
	
end

--특수 소환
function cm.con1fil(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x3d6d)
end
function cm.con1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.con1fil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,5,nil)
end

--세트
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function cm.tar5fil(c,e,tp)
	if not c:IsSetCard(0x3d6d) then return end
	if c:IsType(TYPE_MONSTER) and not c:IsCode(id) then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	elseif c:IsType(TYPE_SPELL+TYPE_TRAP) then 
		return (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable()
	end
	return false
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tar5fil(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar5fil,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,cm.tar5fil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
	elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,tp,LOCATION_GRAVE)
	end
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_MONSTER) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
	end
	elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		if tc:IsType(TYPE_FIELD) then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
			end
		end
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.SSet(tp,tc)
		end
	end
end
