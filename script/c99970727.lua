--[ Refined Spellstone ]
local m=99970727
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c,nil,aux.FBF(Card.IsSetCard,0xd6b))

	--효과 부여: 파괴 + 회복 + 서치
	local e1=MakeEff(c,"I","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e0:SetTarget(cm.eqtar)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	
	--효과 부여: 특수 소환
	local e3=MakeEff(c,"I","M")
	e3:SetD(m,1)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCL(1)
	WriteEff(e3,3,"TO")
	local e2=e0:Clone()
	e2:SetLabelObject(e3)
	c:RegisterEffect(e2)

	--세트
	local e4=MakeEff(c,"STo")
	e4:SetCategory(CATEGORY_LEAVE_GRAVE)
	e4:SetProperty(spinel.delay+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_REMOVE)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	
end

--효과 부여
function cm.eqtar(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function cm.tar1fil(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end 
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and cm.tar1fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar1fil,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.tar1fil,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function cm.op1fil(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xd6c) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Recover(tp,1000,REASON_EFFECT)
		local fg=Duel.GetMatchingGroup(cm.op1fil,tp,LOCATION_DECK,0,nil)
		if #fg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=fg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.tar3fil(c,e,tp)
	return c:IsSetCard(0xd6b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(cm.tar3fil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tar3fil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3206)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		g:GetFirst():RegisterEffect(e1)
	end
end

--세트
function cm.tar4fil(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xd6c) and c:IsSSetable()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.tar4fil(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.tar4fil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,cm.tar4fil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
	end
end
