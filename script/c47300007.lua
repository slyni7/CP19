--트랜캐스터 시에
local m=47300007
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddSquareProcedure(c)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.sscost)
	e2:SetTarget(cm.sstg)
	e2:SetOperation(cm.ssop)
	c:RegisterEffect(e2)

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

cm.square_mana={ATTRIBUTE_EARTH,ATTRIBUTE_EARTH,ATTRIBUTE_EARTH}
cm.custom_type=CUSTOMTYPE_SQUARE


function cm.costfilter(c,e)
	return c:IsSetCard(0xe3e) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SYNCHRO)
end
function cm.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)  and e:GetHandler():IsLocation(LOCATION_REMOVED) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_REMOVED) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end



function cm.gmfilter(c)
	return c:IsSetCard(0xe3e) and c:GetExactManaCount(0x0)>=3
end
function cm.gmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.gmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.gmfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,cm.gmfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.gmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetExactManaCount(0x0)>=3 then

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
	return ATTRIBUTE_EARTH,ATTRIBUTE_EARTH,ATTRIBUTE_EARTH
end
function cm.tval1(e,c)
	return 0x0,0x0,0x0
end
