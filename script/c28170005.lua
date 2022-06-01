--감귤천사 테스카틀리포카
--Darklord Tezcatlipoca
--Scripted by Eerie Code
function c28170005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c28170005.tg1)
	e1:SetOperation(c28170005.op1)
	c:RegisterEffect(e1)
	--copy card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28170005,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCountLimit(1,28170005)
	e2:SetCost(c28170005.cpcost)
	e2:SetTarget(c28170005.cptg)
	e2:SetOperation(c28170005.cpop)
	c:RegisterEffect(e2)	
end

function c28170005.tfilter1(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x2ce) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c28170005.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=eg:FilterCount(c28170005.tfilter1,nil,e,tp)
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>ct
			and ct>0
	end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1+ct,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c28170005.ofilter1(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x2ce) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsRelateToEffect(e)
end
function c28170005.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c28170005.ofilter1,nil,e,tp)
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		return
	end
	if g:GetCount()>Duel.GetLocationCount(tp,LOCATION_MZONE)+1 then
		return
	end
	g:AddCard(c)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c28170005.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c28170005.fil(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x2ce) and c:IsAbleToDeck() and c:CheckActivateEffect(true,true,false)~=nil
end
function c28170005.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c28170005.fil,tp,LOCATION_GRAVE,0,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c28170005.fil,tp,LOCATION_GRAVE,0,1,1,nil)
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
function c28170005.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoDeck(te:GetHandler(),nil,2,REASON_EFFECT)
end