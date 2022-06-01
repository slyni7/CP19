--LMo.73 네트워크 아스테리즘 [　]
local m=112603373
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.shcon)
	e2:SetTarget(cm.shtg)
	e2:SetOperation(cm.shop)
	c:RegisterEffect(e2)
	--atkup
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetRange(LOCATION_FZONE)
	e20:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e20:SetCode(EFFECT_UPDATE_ATTACK)
	e20:SetTarget(cm.atktg)
	e20:SetValue(300)
	c:RegisterEffect(e20)
end

cm.messier_number=73

--fusion material
function cm.ffilter(c)
	return c:IsFusionType(TYPE_MONSTER) and not c:IsLevelAbove(0)
end

--salvage
function cm.shcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.shfilter(c)
	return c:IsSetCard(0xe97) and c:IsLevelAbove(0) and c:IsAbleToHand()
end
function cm.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.shfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.shfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--atkup
function cm.atktg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsLevelAbove(0)
end