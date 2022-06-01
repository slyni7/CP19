--대사적 베네딕투스
function c47800018.initial_effect(c)
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
	e2:SetCountLimit(1,47800018)
	e2:SetCondition(c47800018.spcon)
	e2:SetOperation(c47800018.spop)
	c:RegisterEffect(e2)
	--your deck is mine
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,47800019)
	e3:SetCondition(c47800018.con)
	e3:SetOperation(c47800018.op)
	c:RegisterEffect(e3)
end
function c47800018.rfilter(c,tp)
	return c:IsSetCard(0x49e) and c:IsFaceup() and (c:IsControler(tp) or c:IsFaceup())
end
function c47800018.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c47800018.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c47800018.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c47800018.mzfilter,ct,nil,tp))
end

function c47800018.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c47800018.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,2,2,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c47800018.mzfilter,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c47800018.mzfilter,2,2,nil,tp)
	end
	Duel.Release(g,REASON_COST)
end

function c47800018.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0)<=100 or Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)<=30
end

function c47800018.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	while ct<Duel.GetFieldGroupCount(tp,0,LOCATION_DECK) and Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0)<100-ct do
	ct=ct+1
	end
	if ct>0 then
		local dg=Duel.GetDecktopGroup(1-tp,ct)
		local t=dg:GetFirst()
		while t do
			local cre=t:GetCode()
			local token=Duel.CreateToken(tp,cre)
			Duel.SendtoDeck(token,tp,0,REASON_EFFECT)
			t=dg:GetNext()
			end
	Duel.ShuffleDeck(1-tp)
	Duel.ShuffleDeck(tp)
	end

	local cts=0
	while cts<Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA) and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)<30-cts do
	cts=cts+1
	end
	if cts>0 then
		local dgs=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		local ts=dgs:GetFirst()
		while ts do
			local cres=ts:GetCode()
			local tokens=Duel.CreateToken(tp,cres)
			Duel.SendtoDeck(tokens,tp,1,REASON_EFFECT)
			ts=dgs:GetNext()
		end
	end
end