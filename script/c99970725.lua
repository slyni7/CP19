--[ Refined Spellstone ]
local m=99970725
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c,nil,aux.FBF(Card.IsSetCard,0xd6b))

	--효과 부여: 샐비지
	local e1=MakeEff(c,"FTo","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCL(1,m)
	e1:SetCondition(YuL.turn(0))
	WriteEff(e1,1,"TO")
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e0:SetTarget(cm.eqtar)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)

	--효과 부여:
	local e3=MakeEff(c,"STf")
	e3:SetD(m,1)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCode(EVENT_BATTLED)
	WriteEff(e3,3,"NTO")
	local e2=e0:Clone()
	e2:SetLabelObject(e3)
	c:RegisterEffect(e2)
	
	--특수 소환
	local e4=MakeEff(c,"STo")
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(spinel.delay)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(aux.PreOnfield)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
	
end

--효과 부여
function cm.eqtar(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function cm.tar1fil(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xd6c) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tar1fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar1fil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.tar1fil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsStatus(STATUS_OPPO_BATTLE)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and bc:IsAbleToRemove() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end

--특수 소환
function cm.cost4fil(c)
	return c:IsSetCard(0xd6c) and c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost()
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.IsExistingMatchingCard(cm.cost4fil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cost4fil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tar4fil(c,e,tp)
	return c:IsSetCard(0xd6b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.tar4fil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tar4fil),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
