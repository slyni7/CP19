--[ RainbowFish ]
local m=99970604
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=MakeEff(c,"Qo","HG")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,m)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)

	--도박은 못 참지
	local e2=MakeEff(c,"STf")
	e2:SetCategory(CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetCode(EVENT_TO_GRAVE)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
end

--특수 소환
function cm.cfil1(c)
	return c:IsAbleToRemoveAsCost() and c:IsRainbowFish()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.cfil1,tp,LSTN("H"),0,nil)
	mg:Merge(Duel.GetOverlayGroup(tp,1,1):Filter(cm.cfil1,nil))
	if chk==0 then return #mg>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=mg:Select(tp,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--도박은 못 참지
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local sel=Duel.TossCoin(tp,1)
	if sel==1 then
	--●앞면: 자신 필드에 "레인보우 휘시" 1장을 창조하여 특수 소환한다.
		if Duel.IsPlayerCanSpecialSummonMonster(tp,CARD_RAINBOW_FISH,0,TYPE_MONSTER+TYPE_NORMAL,1800,800,4,RACE_FISH,ATTRIBUTE_WATER) then
			local token=Duel.CreateToken(tp,CARD_RAINBOW_FISH)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	else
	--●뒷면: "레인보우 휘시" 2장을 창조하여 패에 넣는다.
		local g=Group.CreateGroup()
		for i=1,2 do
			local token=Duel.CreateToken(tp,CARD_RAINBOW_FISH)
			g:AddCard(token)
		end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
