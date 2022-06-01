--VIRTUAL YOUTUBER: MIRAI AKARI
local m=99970283
local cm=_G["c"..m]
function cm.initial_effect(c)

	--소환 제약
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	
	--특수 소환 1
	local evtuber=Effect.CreateEffect(c)
	evtuber:SetCategory(CATEGORY_SPECIAL_SUMMON)
	evtuber:SetType(EFFECT_TYPE_IGNITION)
	evtuber:SetRange(LOCATION_HAND)
	evtuber:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	evtuber:SetCondition(cm.spcon)
	evtuber:SetCost(cm.spcost)
	evtuber:SetTarget(cm.sptg)
	evtuber:SetOperation(cm.spop)
	c:RegisterEffect(evtuber)
	
	--공수 반전
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SWAP_AD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e1)
	
	--교환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(cm.chcost)
	e2:SetTarget(cm.chtg)
	e2:SetOperation(cm.chop)
	e2:SetCountLimit(2)
	c:RegisterEffect(e2)
	
	--특수 소환 2
	local eakari=Effect.CreateEffect(c)
	eakari:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	eakari:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	eakari:SetCode(EVENT_TO_GRAVE)
	eakari:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	eakari:SetCondition(cm.akaricon)
	eakari:SetTarget(cm.akaritg)
	eakari:SetOperation(cm.akariop)
	c:RegisterEffect(eakari)
	
end

--특수 소환 1
function cm.spconfil(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.spcon(e)
	return Duel.IsExistingMatchingCard(cm.spconfil,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,1,nil)
		and not Duel.IsExistingMatchingCard(cm.spconfil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function cm.spcfilter(c)
	return c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_EXTRA) and c:IsAbleToRemoveAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=4 end
	local rg=Group.CreateGroup()
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		rg:AddCard(sg:GetFirst())
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end

--교환
function cm.cfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsPublic()
end
function cm.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(g:GetFirst())
	g:GetFirst():CreateEffectRelation(e)
end
function cm.filter(c)
	return c:IsAbleToChangeControler() and c:IsAbleToHand() and not c:IsType(TYPE_TOKEN)
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=e:GetLabelObject()
	if Duel.IsChainDisablable(0) and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		Duel.Release(tc,REASON_EFFECT)
		Duel.NegateEffect(0)
		return
	end
	if g:IsRelateToEffect(e) and Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)~=0
		and tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end

--특수 소환 2
function cm.akaricon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.owfilter(c)
	return c:GetControler()~=c:GetOwner()
end
function cm.akaritg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsStatus(STATUS_PROC_COMPLETE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.owfilter,tp,LOCATION_MZONE,0,1,nil)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.akariop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local tc=g:GetFirst()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_DEFENSE)~=0 then
		while tc do
			if not tc:IsImmuneToEffect(e) then
				tc:ResetEffect(EFFECT_SET_CONTROL,RESET_CODE)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_CONTROL)
				e1:SetValue(tc:GetOwner())
				e1:SetReset(RESET_EVENT+0xec0000)
				tc:RegisterEffect(e1)
			end
			tc=g:GetNext()
		end
	end
end
