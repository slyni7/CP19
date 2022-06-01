--BLiTz(블리츠)의 개발자 플래닛
local m=112603201
local cm=_G["c"..m]
function cm.initial_effect(c)

	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_HAND)
	e6:SetCountLimit(1,m)
	e6:SetCost(cm.spcost)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
	
	--BLiTz Vehicle Factory
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m+1)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
	
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetRange(LOCATION_SZONE)
	e1:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+2)
	e1:SetTarget(cm.thtg1)
	e1:SetOperation(cm.thop1)
	c:RegisterEffect(e1)
	
	--hand set
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MONSTER_SSET)
	e0:SetValue(TYPE_SPELL)
	c:RegisterEffect(e0)
	
	--grave set
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(m,3))
	ea:SetRange(LOCATION_GRAVE)
	ea:SetType(EFFECT_TYPE_IGNITION)
	ea:SetCondition(aux.exccon)
	ea:SetCountLimit(1,m+3)
	ea:SetValue(TYPE_SPELL)
	ea:SetCost(cm.setcost)
	ea:SetTarget(cm.settg)
	ea:SetOperation(cm.setop)
	c:RegisterEffect(ea)
	
end

--spsummon
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xe9c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--BLiTz Vehicle Factory
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local val=1+math.floor(math.random()*11)
	if val==1 then
		local token=Duel.CreateToken(p,112603205)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-p,token)
	elseif val==2 then
		local token=Duel.CreateToken(p,112603206)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-p,token)	
	elseif val==3 then
		local token=Duel.CreateToken(p,112603207)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-p,token)		
	elseif val==4 then
		local token=Duel.CreateToken(p,112603208)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-p,token)		
	elseif val==5 then
		local token=Duel.CreateToken(p,112603210)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-p,token)			
	elseif val==6 then
		local token=Duel.CreateToken(p,112603212)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-p,token)		
	elseif val==7 then
		local token=Duel.CreateToken(p,112603214)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-p,token)		
	elseif val==8 then
		local token=Duel.CreateToken(p,112603215)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-p,token)			
	elseif val==9 then
		local token=Duel.CreateToken(p,112603216)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-p,token)		
	elseif val==11 then
		local token=Duel.CreateToken(p,112603217)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-p,token)	
	elseif val==12 then
		local token=Duel.CreateToken(p,112603218)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-p,token)	
	else
	end
end

--set
function cm.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end

--search
function cm.thfilter1(c)
	return c:IsSetCard(0xe9c) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end