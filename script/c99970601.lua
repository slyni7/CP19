--[ RainbowFish ]
local m=99970601
local cm=_G["c"..m]
function cm.initial_effect(c)

	--레인보우 휘시 사냥이다!
	local e1=MakeEff(c,"STo")
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCL(1,m)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	--덤핑
	local e3=MakeEff(c,"I","M")
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetCL(1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	
	--공수 증가
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(cm.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)

end

--레인보우 휘시 사냥이다!
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Group.CreateGroup()
	for i=1,3 do
		local token=Duel.CreateToken(tp,CARD_RAINBOW_FISH)
		g:AddCard(token)
	end
	Duel.DisableShuffleCheck()
	Duel.SendtoDeck(g,nil,1,REASON_RULE)
	Duel.Overlay(c,g)
end

--덤핑
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetOverlayGroup():Filter(Card.IsAbleToRemoveAsCost,nil)
	if chk==0 then return #mg>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=mg:Select(tp,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.gyfilter(c)
	return c:IsRainbowFishCard() and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.gyfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.gyfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--공수 증가
function cm.atkval(e,c)
	local fishM=Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsRainbowFish),c:GetControler(),LSTN("M"),LSTN("M"),nil)
	local fishX=Duel.GetOverlayGroup(c:GetControler(),1,1):Filter(Card.IsRainbowFish,nil):GetCount()
	return (fishM+fishX)*200
end
