--모듈 에고이스트
local m=99970429
local cm=_G["c"..m]
function cm.initial_effect(c)

	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,nil,aux.FilterBoolFunction(Card.IsModuleSetCard,0xe1d),1,99,nil)
	
	--공격력
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.valop)
	c:RegisterEffect(e1)
	
	--효과 파괴 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(cm.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	--샐비지
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(spinel.delay+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	
end

--공격력
function cm.valop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_MODULE) then return end
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local atk=0
	while tc do
		local tatk=tc:GetTextAttack()
		if tatk<0 then tatk=0 end
		atk=atk+tatk
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end

--효과 파괴 내성
function cm.indcon(e)
	return e:GetHandler():GetAttack()>=2500
end

--샐비지
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipCount()>0 and e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function cm.thfilter(c)
	return c:IsSetCard(0xe1d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
