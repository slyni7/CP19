--[ RainbowFish ]
local m=99970602
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	
	--드로우
	local e2=MakeEff(c,"I","M")
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCL(1,m)
	e2:SetCost(cm.cost2)
	e2:SetTarget(spinel.drawtg(0,2))
	e2:SetOperation(spinel.drawop)
	c:RegisterEffect(e2)
	
	--서치 / 샐비지
	local e3=MakeEff(c,"I","G")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCondition(aux.exccon)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	
end

--특수 소환
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetOverlayGroup(c:GetControler(),1,1):Filter(Card.IsRainbowFish,nil):GetCount()>0
end

--드로우
function cm.cfil2(c)
	return c:IsAbleToRemoveAsCost() and c:IsRainbowFish()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.cfil2,tp,LSTN("H"),0,nil)
	mg:Merge(Duel.GetOverlayGroup(tp,1,1):Filter(cm.cfil2,nil))
	if chk==0 then return #mg>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=mg:Select(tp,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--서치 / 샐비지
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.thfilter(c)
	return c:IsCode(CARD_FISH_N_BACKS) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
