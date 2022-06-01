--영혼사적 아잘리나
function c47800014.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,47800014)
	e2:SetCondition(c47800014.spcon)
	e2:SetOperation(c47800014.spop)
	c:RegisterEffect(e2)
	--hand copy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,47800015)
	e3:SetCondition(c47800014.con)
	e3:SetOperation(c47800014.op)
	c:RegisterEffect(e3)
end
function c47800014.rfilter(c,tp)
	return c:IsSetCard(0x49e) and c:IsFaceup() and (c:IsControler(tp) or c:IsFaceup())
end
function c47800014.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c47800014.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c47800014.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-1 and rg:GetCount()>0 and (ft>0 or rg:IsExists(c47800014.mzfilter,ct,nil,tp))
end
function c47800014.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c47800014.rfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end

function c47800014.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0)<=120
end

function c47800014.op(e,tp,eg,ep,ev,re,r,rp)
	local h=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,e:GetHandler())
	Duel.Delete(e,h)

	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()<1 then return end
	local t=g:GetFirst()
	while t do
	local cre=t:GetCode()
	local token=Duel.CreateToken(tp,cre)
	Duel.SendtoHand(token,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
	t=g:GetNext()
	end
end
