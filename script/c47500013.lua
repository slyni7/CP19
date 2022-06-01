--사피론 오로라
function c47500013.initial_effect(c)
	
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c47500013.matfilter),3,2)
	c:EnableReviveLimit()

	--deck_bounce
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,47500013)
	e1:SetCost(c47500013.cost)
	e1:SetCondition(c47500013.con)
	e1:SetTarget(c47500013.tdtg)
	e1:SetOperation(c47500013.tdop)
	c:RegisterEffect(e1)

	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,47500113)
	e2:SetTarget(c47500013.mattg)
	e2:SetOperation(c47500013.matop)
	c:RegisterEffect(e2)

	--tal ju
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,47500213)
	e3:SetCost(c47500013.spcost)
	e3:SetCondition(c47500013.spcon)
	e3:SetTarget(c47500013.sptg)
	e3:SetOperation(c47500013.spop)
	c:RegisterEffect(e3)   
	

end


function c47500013.matfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_WIND)
end

function c47500013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end



function c47500013.con(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
	e:SetLabelObject(d)
	return a:IsSetCard(0x475) and a:IsFaceup()
end

function c47500013.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc and tc:IsAbleToDeck() end
	local g=Group.FromCards(c,tc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c47500013.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToBattle() and tc:IsControler(1-tp) then
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,800,REASON_EFFECT)
		end
	end
end



function c47500013.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x475) and c:IsType(TYPE_XYZ)
end
function c47500013.mfilter(c)
	return c:IsSetCard(0x475) and c:IsCanOverlay()
end
function c47500013.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c47500013.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c47500013.mfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c47500013.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=Duel.SelectTarget(tp,c47500013.mfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
end
function c47500013.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,tc,e)
	if g:GetCount()>0 then
		Duel.Overlay(tc,g)
	end
end




function c47500013.filters(c,e,tp)
	return c:IsSetCard(0x475) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(47500013) and c:IsType(TYPE_MONSTER)
end

function c47500013.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(c)
end

function c47500013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end


function c47500013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c47500013.filters,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function c47500013.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=2
	if Duel.IsPlayerAffectedByEffect(tp,59822133,14941411) or ft<2 then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47500013.filters),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,ct,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc=g:GetNext()
	end
end
