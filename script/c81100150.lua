function c81100150.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c81100150.mfilter0,aux.FilterBoolFunction(Card.IsType,TYPE_LINK),false)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c81100150.lim)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c81100150.cn1)
	e1:SetOperation(c81100150.op1)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c81100150.tg)
	e2:SetOperation(c81100150.op)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81100150,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81100150)
	e3:SetCondition(c81100150.ecn)
	e3:SetCost(c81100150.eco)
	e3:SetTarget(c81100150.etg)
	e3:SetOperation(c81100150.eop)
	c:RegisterEffect(e3)
end

--summon method
function c81100150.mfilter(c)
	return c:IsSetCard(0xcad) and c:IsType(TYPE_PENDULUM)
end
function c81100150.lim(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c81100150.sfilter0(c,fc)
	return ( c:IsSetCard(0xcad) and c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_LINK) )
	and c:IsCanBeFusionMaterial(fc)
end
function c81100150.sfilter1(c,tp,g)
	return g:IsExists(c81100150.sfilter2,1,c,tp,c)
end
function c81100150.sfilter2(c,tp,mc)
	return ( c:IsSetCard(0xcad) and c:IsType(TYPE_PENDULUM) ) and mc:IsType(TYPE_LINK)
	or c:IsType(TYPE_LINK) and mc:IsSetCard(0xcad) and mc:IsType(TYPE_PENDULUM)
	and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c81100150.cn1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c81100150.sfilter0,nil,c)
	return rg:IsExists(c81100150.sfilter1,1,nil,tp,rg)
end
function c81100150.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c81100150.sfilter0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=rg:FilterSelect(tp,c81100150.sfilter1,1,1,nil,tp,rg)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=rg:FilterSelect(tp,c81100150.sfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end

--e1
function c81100150.filter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER)
end
function c81100150.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81100150.filter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81100150.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81100150.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--handes
function c81100150.filter3(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsSetCard(0xcad)
end
function c81100150.ecn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT)~=0 and eg:IsExists(Card.IsControler,1,nil,1-tp)
	and Duel.GetCurrentPhase()~=PHASE_DRAW
	and Duel.IsExistingMatchingCard(c81100150.filter3,tp,LOCATION_EXTRA,0,1,nil)
end
function c81100150.filter2(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_PENDULUM)
end
function c81100150.eco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81100150.filter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	local g=Duel.SelectMatchingCard(tp,c81100150.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81100150.etg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_HAND)
end
function c81100150.eop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,2)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
end
