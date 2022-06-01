--트랜캐스터 우노

local m=47300001
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)

	--give mana
	local e99=Effect.CreateEffect(c)
	e99:SetDescription(aux.Stringid(m,1))
	e99:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e99:SetType(EFFECT_TYPE_QUICK_O)
	e99:SetRange(LOCATION_GRAVE)
	e99:SetCode(EVENT_FREE_CHAIN)
	e99:SetHintTiming(0,TIMING_END_PHASE)
	e99:SetCountLimit(1,m+1000)
	e99:SetCost(aux.bfgcost)
	e99:SetTarget(cm.gmtg)
	e99:SetOperation(cm.gmop)
	c:RegisterEffect(e99)

end

cm.square_mana={ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT}
cm.custom_type=CUSTOMTYPE_SQUARE

function cm.filter(c,tp)
	return c:GetPreviousControler()==tp and c:IsSetCard(0xe3e) and c:IsType(TYPE_MONSTER)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end



function cm.gmfilter(c)
	return c:IsSetCard(0xe3e) and c:GetExactManaCount(0x0)>=2
end
function cm.gmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.gmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.gmfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,cm.gmfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.gmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetExactManaCount(0x0)>=2 then

		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(cm.oval1)
		tc:RegisterEffect(e1)

		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_SQUARE_MANA_DECLINE)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		e2:SetValue(cm.tval1)
		tc:RegisterEffect(e2)

	end
end

function cm.oval1(e,c)
	return ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT
end
function cm.tval1(e,c)
	return 0x0,0x0
end