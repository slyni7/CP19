--[ Refined Spellstone ]
local m=99970724
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c,nil,aux.FBF(Card.IsSetCard,0xd6b))

	--효과 부여: 파괴
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetD(m,0)
	e1:SetCost(YuL.LPcost(2000))
	WriteEff(e1,1,"TO")
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e0:SetTarget(cm.eqtar)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	
	--효과 부여: 덤핑
	local e3=MakeEff(c,"FTf","M")
	e3:SetD(m,1)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCL(1)
	e3:SetCondition(YuL.turn(0))
	WriteEff(e3,3,"TO")
	local e2=e0:Clone()
	e2:SetLabelObject(e3)
	c:RegisterEffect(e2)
	
	--서치 + 샐비지
	local e4=MakeEff(c,"I","G")
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCost(aux.bfgcost)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)

end

--효과 부여
function cm.eqtar(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function cm.tar1fil(c,g)
	return not g:IsContains(c)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar1fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c:GetEquipGroup()) end
	local sg=Duel.GetMatchingGroup(cm.tar1fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,c:GetEquipGroup())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.tar1fil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e:GetHandler():GetEquipGroup())
	Duel.Destroy(sg,REASON_EFFECT)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,4)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,4,REASON_EFFECT)
end

--서치 + 샐비지
function cm.con4fil(c)
	return c:IsSetCard(0xd6c) and c:IsType(TYPE_EQUIP)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.con4fil,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=4
end
function cm.tar4fil(c)
	return c:IsSetCard(0xd6b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tar4fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tar4fil),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
