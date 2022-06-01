--XXX
local m=99970353
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.sumcon)
	e1:SetTarget(cm.sumtg)
	e1:SetOperation(cm.sumop)
	c:RegisterEffect(e1)
	
	--회수 + 무효
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)

	--무효
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e5:SetTarget(cm.disable)
	c:RegisterEffect(e5)

end

--특수 소환
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(99970351)
end
function cm.recfilter(c)
	return c:IsSetCard(0xe11)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local val=Duel.GetMatchingGroupCount(cm.recfilter,tp,LOCATION_GRAVE,0,nil)*200
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Recover(tp,val,REASON_EFFECT)
	end
end

--회수 + 무효
function cm.filter1(c)
	return c:IsSetCard(0xe11) and c:IsAbleToDeck()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.filter1(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(cm.filter1,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		Debug.Message("하하하하하, 그제야 알았지. 하하! 언제나 웃을 수 있다는 것이, 크크, 얼마나 괴로운 일인지!")
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
		e1:SetTarget(cm.distg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetOperation(cm.disop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local etm=Effect.CreateEffect(c)
		etm:SetType(EFFECT_TYPE_FIELD)
		etm:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		etm:SetRange(LOCATION_SZONE)
		etm:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		etm:SetTarget(cm.distg)
		Duel.RegisterEffect(etm,tp)
	end
end
function cm.distg(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_SPELL) and not c:IsType(TYPE_FIELD)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_FIELD) and re:IsActiveType(TYPE_SPELL) then
		Duel.NegateEffect(ev)
	end
end

--무효
function cm.disable(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c)
end
