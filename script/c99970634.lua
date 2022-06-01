--[ hololive 1st Gen ]
local m=99970634
local cm=_G["c"..m]
function cm.initial_effect(c)

	--엑시즈 소환
	RevLim(c)
	aux.AddXyzProcedure(c,aux.FBF(Card.IsSetCard,0xe19),4,3)
	
	--펜듈럼
	Pendulum.AddProcedure(c,false)

	--P: 특수 소환
	local e1=MakeEff(c,"I","P")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

	--M: 바운스
	local e3=MakeEff(c,"I","M")
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(spinel.rmovcost(1))
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(cm.con4)
	c:RegisterEffect(e4)
	
	--M: 펜듈럼 세팅
	local e5=MakeEff(c,"STo")
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	WriteEff(e5,5,"NTO")
	c:RegisterEffect(e5)
	
end

--P: 특수 소환
function cm.tfil1(c)
	return c:IsFaceup() and c:IsSetCard(0xe19)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and cm.tfil1(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(cm.tfil1,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.tfil1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e2=Effect.CreateEffect(c)
		e2:SetD(m,0)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetValue(LOCATION_DECK)
		e2:SetReset(RESET_EVENT+0x47e0000)
		c:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
	if tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.BreakEffect()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end

--M: 바운스
function cm.con3fil(c)
	return c:IsFaceup() and c:IsSetCard(0xd66)
end
function cm.con3(e)
	return not Duel.IsExistingMatchingCard(cm.con3fil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,4,nil)
end
function cm.con4(e)
	return Duel.IsExistingMatchingCard(cm.con3fil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,4,nil)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--M: 펜듈럼 세팅
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
