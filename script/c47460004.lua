function c47460004.initial_effect(c)
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
	e2:SetCondition(c47460004.spcon)
	e2:SetOperation(c47460004.spop)
	c:RegisterEffect(e2)
	--allkill
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47460004,0))
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,47460004+EFFECT_COUNT_CODE_DUEL)
	e3:SetTarget(c47460004.destg)
	e3:SetOperation(c47460004.desop)
	c:RegisterEffect(e3)
end

function c47460004.rfilter(c,tp)
	return c:IsControler(tp) or c:IsFaceup()
end
function c47460004.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c47460004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c47460004.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local cot=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local gs=Duel.GetDecktopGroup(tp,cot)
	return ft>-3 and rg:GetCount()>2 and (ft>0 or rg:IsExists(c47460004.mzfilter,ct,nil,tp)) and gs:GetClassCount(Card.GetCode)==gs:GetCount()
end
function c47460004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c47460004.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,3,3,nil)
	elseif ft>-2 then
		local ct=-ft+1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c47460004.mzfilter,ct,ct,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,3-ct,3-ct,g)
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c47460004.mzfilter,3,3,nil,tp)
	end
	Duel.Release(g,REASON_COST)
end

function c47460004.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c47460004.akfilter(c,code)
	return c:IsCode(code)
end
function c47460004.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local tcc=tc:GetCode()
		sg=Duel.GetMatchingGroup(c47460004.akfilter,tp,0,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,nil,tcc)
		
		Duel.Delete(e,sg)

	end
end