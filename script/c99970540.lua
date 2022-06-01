--[Owl-Eyes]
local m=99970540
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	YuL.Activate(c)
	
	--장착 / 특수 소환
	local e1=MakeEff(c,"Qo","S")
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--공격 횟수 추가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe13))
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
	
end

--장착 / 특수 소환
function cm.etfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xe13)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function cm.filter(c,e,tp,code)
	return c:IsSetCard(0xe13) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and (not c:IsForbidden() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.etfilter(chkc,e,tp) end
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
		and Duel.IsExistingTarget(cm.etfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.etfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0)
		or not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) and g:GetCount()>0 then
		local sc=g:GetFirst()
		if sc then
			if sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
				Duel.Equip(tp,sc,tc,false)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.eqlimit)
				sc:RegisterEffect(e1)
			end
		end
	end
end
function cm.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() or e:GetHandler():GetEquipTarget()==c
end

--공격 횟수 추가
function cm.val(e,c)
	return c:GetEquipCount()
end
