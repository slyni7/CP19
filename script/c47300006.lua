--트랜캐스터 시즈
local m=47300006
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddSquareProcedure(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tktg)
	e1:SetOperation(cm.tkop)
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

cm.square_mana={ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT}
cm.custom_type=CUSTOMTYPE_SQUARE


function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,47300100,0xe3e,0x4011,0,1500,3,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,47300100,0xe3e,0x4011,0,1500,3,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,47300100)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)

	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
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
	return ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT
end
function cm.tval1(e,c)
	return 0x0,0x0,0x0
end
