--괴뢰사단의 장송 인형
local m=52648110
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),2,2,cm.mfil0)
	
	--스탯
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.tg1)
	e1:SetValue(cm.va1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	
	--견제
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+10000000)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--소생
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.co4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end

--링크 소재
function cm.mfil0(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x5fe)
end

--스탯
function cm.tg1(e,c)
	return c:IsFaceup() and c:IsCode(52648109)
end
function cm.tfil0(c)
	return c:IsFaceup() and c:IsType(0x1)
end
function cm.va1(e,c)
	local g=Duel.GetMatchingGroup(cm.tfil0,e:GetHandlerPlayer(),LOCATION_GRAVE,LOCATION_GRAVE,nil)
	return g:GetClassCount(Card.GetCode)*100
end

--견제
function cm.nfil0(c,tp)
	return c:IsFaceup() and c:IsCode(52648109) and c:GetControler()==tp
end
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil0,1,nil,tp)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return true
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,0,0x0c,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,0x0c,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

--소생
function cm.cfil0(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x5fe) and c:IsType(0x1)
end
function cm.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft==0 then loc=loc+LOCATION_MZONE end
	if ft>0 then loc=loc+LOCATION_MZONE+LOCATION_HAND end
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,loc,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,loc,0,1,1,c)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.spfil0(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsSetCard(0x5fe) and not c:IsCode(code)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetLabel()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(cm.spfil0,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,code)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,code)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
