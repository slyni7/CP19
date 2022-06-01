--감귤천사 루시페르
--Darklord Lucifer
--Scripted by Eerie Code
function c28170003.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28170003,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c28170003.sumcon)
	e1:SetOperation(c28170003.sumop)
	e1:SetValue(SUMMON_TYPE_TRIBUTE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28170003,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c28170003.spcon)
	e2:SetTarget(c28170003.sptg)
	e2:SetOperation(c28170003.spop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7430,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCountLimit(1,28170003)
	e2:SetCost(c28170003.cpcost)
	e2:SetTarget(c28170003.cptg)
	e2:SetOperation(c28170003.cpop)
	c:RegisterEffect(e2)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28170003,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c28170003.condition)
	e1:SetTarget(c28170003.target)
	e1:SetOperation(c28170003.operation)
	c:RegisterEffect(e1)
end
function c28170003.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c28170003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function c28170003.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,ct*500,REASON_EFFECT)
end


function c28170003.mfilter(c,tp)
	return c:IsSetCard(0x2ce) and (c:IsControler(tp) or c:IsFaceup())
end
function c28170003.sumcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c28170003.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return c:IsLevelAbove(7) and Duel.GetTributeCount(c,mg)>0
end
function c28170003.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c28170003.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c28170003.spcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function c28170003.spfil(c,e,tp)
	return c:IsSetCard(0x2ce) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28170003.spcfil(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c28170003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local mg=Duel.GetMatchingGroupCount(c28170003.spcfil,tp,0,LOCATION_MZONE,nil)
		return lc>0 and mg>0 and Duel.IsExistingMatchingCard(c28170003.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) 
	end
end
function c28170003.spop(e,tp,eg,ep,ev,re,r,rp)
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if lc<1 then return end
	local mg=Duel.GetMatchingGroupCount(c28170003.spcfil,tp,0,LOCATION_MZONE,nil)
	if mg==0 then return end
	local mc=math.min(lc,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c28170003.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,mc,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c28170003.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c28170003.fil(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x2ce) and c:IsAbleToDeck() and c:CheckActivateEffect(true,true,false)~=nil
end
function c28170003.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c28170003.fil,tp,LOCATION_GRAVE,0,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c28170003.fil,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c28170003.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoDeck(te:GetHandler(),nil,2,REASON_EFFECT)
end