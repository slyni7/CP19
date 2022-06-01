--사적의 애완용 네파리안
function c47800016.initial_effect(c)
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
	e2:SetCountLimit(1,47800016)
	e2:SetCondition(c47800016.spcon)
	e2:SetOperation(c47800016.spop)
	c:RegisterEffect(e2)
	--m&t 2
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,47800017)
	e3:SetCondition(c47800016.con)
	e3:SetTarget(c47800016.tar)
	e3:SetOperation(c47800016.op)
	c:RegisterEffect(e3)
end
function c47800016.rfilter(c,tp)
	return c:IsSetCard(0x49e) and c:IsFaceup() and (c:IsControler(tp) or c:IsFaceup())
end
function c47800016.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c47800016.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c47800016.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c47800016.mzfilter,ct,nil,tp))
end
function c47800016.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c47800016.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,2,2,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c47800016.mzfilter,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c47800016.mzfilter,2,2,nil,tp)
	end
	Duel.Release(g,REASON_COST)
end


function c47800016.fil(c)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function c47800016.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0)<=120
end
function c47800016.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c47800016.fil,tp,0,LOCATION_DECK,nil)>1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end

function c47800016.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c47800016.fil,tp,0,LOCATION_DECK,nil)
	if g:GetCount()<2 then return end
	local dg=g:RandomSelect(tp,2)
	local t=dg:GetFirst()
	while t do
	local cre=t:GetCode()
	local token=Duel.CreateToken(tp,cre)
	Duel.SendtoHand(token,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
	t=dg:GetNext()
	end
	Duel.ShuffleDeck(1-tp)
end
