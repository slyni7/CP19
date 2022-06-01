--하이랜드 세타
function c47460005.initial_effect(c)
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
	e2:SetCondition(c47460005.spcon)
	e2:SetOperation(c47460005.spop)
	c:RegisterEffect(e2)
	--allkill
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47460005,0))
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCountLimit(1,47460005+EFFECT_COUNT_CODE_DUEL)
	e3:SetTarget(c47460005.tg)
	e3:SetOperation(c47460005.op)
	c:RegisterEffect(e3)
end

function c47460005.rfilter(c,tp)
	return c:IsControler(tp) or c:IsFaceup()
end
function c47460005.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c47460005.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c47460005.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local cot=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local gs=Duel.GetDecktopGroup(tp,cot)
	return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c47460005.mzfilter,ct,nil,tp)) and gs:GetClassCount(Card.GetCode)==gs:GetCount()
end
function c47460005.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c47460005.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,2,2,nil)
	elseif ft>-1 then
		local ct=-ft+1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c47460005.mzfilter,ct,ct,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,2-ct,2-ct,g)
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c47460005.mzfilter,2,2,nil,tp)
	end
	Duel.Release(g,REASON_COST)
end

function c47460005.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c47460005.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)

	if Duel.Draw(p,d,REASON_EFFECT) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_HAND_LIMIT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(8)
		Duel.RegisterEffect(e1,p)
	end
end