--DR-Ÿ�̴�
function c17282640.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17282640,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,17282640)
	e1:SetCost(c17282640.hspcost)
	e1:SetTarget(c17282640.hsptg)
	e1:SetOperation(c17282640.hspop)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17282640,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17282640)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(c17282640.retcon)
	e2:SetTarget(c17282640.rettg)
	e2:SetOperation(c17282640.retop)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17282640,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,17282640)
	e3:SetCost(c17282640.tgcost)
	e3:SetTarget(c17282640.tgtg)
	e3:SetOperation(c17282640.tgop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17282640,3))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,17282640)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c17282640.thtg)
	e4:SetOperation(c17282640.thop)
	c:RegisterEffect(e4)
	aux.EnablePendulumAttribute(c)
	local e5=e1:Clone()
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,17282641)
	e5:SetCost(c17282640.pspcost)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,17282641)
	e6:SetCost(c17282640.pecost)
	e6:SetTarget(c17282640.petg)
	e6:SetOperation(c17282640.peop)
	e6:SetLabelObject(e3)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(17282640,2))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetRange(LOCATION_PZONE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1,17282641)
	e7:SetTarget(c17282640.prettg)
	e7:SetOperation(c17282640.pretop)
	c:RegisterEffect(e7)
end
function c17282640.prettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c17282640.pretop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c17282640.pecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
end
function c17282640.pefil(c)
	return c:GetOriginalAttribute()==ATTRIBUTE_WATER
end
function c17282640.petg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local le=e:GetLabelObject()
	local ltg=le:GetTarget()
	if chkc then
		return ltg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then
		return Duel.IsExistingMatchingCard(c17282640.pefil,tp,LOCATION_PZONE,0,1,c)
			and ltg(e,tp,eg,ep,ev,re,r,rp,0)
	end
	ltg(e,tp,eg,ep,ev,re,r,rp,1)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c17282640.peop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if g:GetCount()<2 then
		return
	end
	Duel.Destroy(g,REASON_EFFECT)
	local le=e:GetLabelObject()
	local lop=le:GetOperation()
	lop(e,tp,eg,ep,ev,re,r,rp)
end
function c17282640.prfilter(c)
	return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_FIRE)) and c:IsAbleToRemoveAsCost() and c:IsFaceup()
end
function c17282640.pspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17282640.prfilter,tp,LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c17282640.prfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c17282640.rfilter(c)
	return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER)) and c:IsAbleToRemoveAsCost()
end
function c17282640.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17282640.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c17282640.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c17282640.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17282640.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c17282640.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c17282640.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c17282640.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c17282640.dfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c17282640.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and e:GetHandler():IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c17282640.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c17282640.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c17282640.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c17282640.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17282640.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c17282640.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c17282640.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c17282640.thfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function c17282640.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17282640.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17282640.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17282640.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
