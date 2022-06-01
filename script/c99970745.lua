--[ I LOVE... ]
local m=99970745
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Link summon method
	c:EnableReviveLimit()
	Link.AddProcedure(c,cm.matfilter,1,1)
	--Unaffected by trap effects, continuous effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(cm.immcon)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	--Special summon a "Traptrix" monster from deck, optional trigger effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--Set 1 "Trap Hole" normal trap card from deck, optional trigger effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m+100000000)
	e5:SetCondition(cm.setcon)
	e5:SetTarget(cm.settg)
	e5:SetOperation(cm.setop)
	c:RegisterEffect(e5)
end

	--Link material of a non-link "Traptrix" monster
function cm.matfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x5d6d,lc,sumtype,tp) and not c:IsType(TYPE_LINK,lc,sumtype,tp)
end
	--If this card was link summoned
function cm.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
	--Unaffected by trap effects
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
	--If a normal trap card is activated
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x5d6d) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
	--Check names of monsters
function cm.namefilter(c,cd)
	return c:IsCode(cd) and c:IsFaceup()
end
	--Check for "Traptrix" monster
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x5d6d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(cm.namefilter,tp,LOCATION_MZONE,0,1,nil,c:GetCode())
end
	--Activation legality
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
	--Performing the effect of special summoning a "Traptrix" monster with different name from controlled monsters
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
	--If your "Traptrix" monster effect activates, except this card
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSetCard(0x5d6d) and re:GetHandler()~=e:GetHandler()
end
	--Check for "Trap Hole" normal trap
function cm.setfilter(c)
	return c:IsSetCard(0x5d6d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
	--Activation legality
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
	--Performing the effect of setting 1 "Trap Hole" normal trap from deck to S/T zones
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end


