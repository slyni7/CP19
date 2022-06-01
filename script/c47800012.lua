--비밀결사단 어둠 사적
function c47800012.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,47800012)
	e1:SetCondition(c47800012.spcon)
	e1:SetOperation(c47800012.spop)
	c:RegisterEffect(e1)

	--Gam-sa
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47800012,0))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,47800013)
	e3:SetTarget(c47800012.tar1)
	e3:SetCondition(c47800012.condition)
	e3:SetOperation(c47800012.operation)
	c:RegisterEffect(e3)
end

function c47800012.rfilter(c,tp)
	return c:IsSetCard(0x49e) and c:IsFaceup() and (c:IsControler(tp) or c:IsFaceup())
end
function c47800012.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c47800012.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c47800012.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-1 and rg:GetCount()>0 and (ft>0 or rg:IsExists(c47800012.mzfilter,ct,nil,tp))
end
function c47800012.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c47800012.rfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end

function c47800012.tfil1(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and c:GetAttack()<=1500
end
function c47800012.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c47800012.tfil1,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c47800012.tfil1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end

function c47800012.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end

function c47800012.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c47800012.tfil1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.GetControl(g,tp)
end